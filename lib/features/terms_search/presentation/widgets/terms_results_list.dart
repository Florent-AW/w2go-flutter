// features/terms_search/presentation/widgets/terms_results_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/models/search/result_section.dart';
import '../../application/terms_results_sections_notifier.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../shared_ui/presentation/widgets/molecules/featured_experience_card.dart';
import '../../../../core/theme/components/atoms/section_title.dart';
import '../../../../core/theme/app_dimensions.dart';

class TermsResultsListSectioned extends ConsumerWidget {
  final TermsResultsSectionsStatus requestStatus;
  final List<ResultSection> sections;
  final VoidCallback onRetry;
  final String emptyMessage;

  const TermsResultsListSectioned({
    super.key,
    required this.requestStatus,
    required this.sections,
    required this.onRetry,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (requestStatus) {
      case TermsResultsSectionsStatus.loading:
        return _buildSkeleton();
      case TermsResultsSectionsStatus.error:
        return _buildError(context);
      case TermsResultsSectionsStatus.empty:
        return _buildEmpty(context);
      case TermsResultsSectionsStatus.success:
        return _buildList(context);
      case TermsResultsSectionsStatus.idle:
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSkeleton() {
    return Column(
      children: List.generate(
        6,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Une erreur est survenue.', style: TextStyle(color: theme.colorScheme.onErrorContainer)),
            ),
            TextButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(child: Text(emptyMessage)),
    );
  }

  Widget _buildList(BuildContext context) {
    // Render sections sequentially with headers and cards
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final section in sections)
          if (section.items.isNotEmpty) ...[
            // Align exact spacing with carousel header bottom padding (spacingXs = 12)
            SectionTitle.secondary(text: section.title, bottomSpacing: AppDimensions.spacingXs),
            ...section.items.map((a) {
              final experience = ExperienceItem.activity(a);
              return Padding(
                key: ValueKey(a.base.id),
                // Slightly tighter vertical space between cards, consistent compact layout
                padding: EdgeInsets.only(bottom: AppDimensions.spacingXxxs),
                child: FeaturedExperienceCard(
                  experience: experience,
                  heroTag: a.base.id,
                  // Distance badge consumes meters; convert km -> m for fallback
                  overrideDistance: a.distance != null ? a.distance! * 1000 : null,
                  showDistance: true,
                ),
              );
            }),
          ],
      ],
    );
  }
}
