// lib/features/experience_detail/presentation/organisms/experience_description_panel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/components/atoms/section_title.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../application/providers/experience_detail_providers.dart';

class ExperienceDescriptionPanel extends ConsumerStatefulWidget {
  final ExperienceItem experienceItem;

  const ExperienceDescriptionPanel({
    Key? key,
    required this.experienceItem,
  }) : super(key: key);

  @override
  ConsumerState<ExperienceDescriptionPanel> createState() => _ExperienceDescriptionPanelState();
}

class _ExperienceDescriptionPanelState extends ConsumerState<ExperienceDescriptionPanel> {
  bool _expanded = false;

  static const int _maxLines = 5;
  static const int _expandedMaxLines = 50;

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(experienceDetailProvider(widget.experienceItem));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return detailState.when(
      initial: () => _buildSkeleton(context),
      loading: () => _buildSkeleton(context),
      error: (_) => const SizedBox.shrink(),
      loaded: (details) {
        if (details.description == null || details.description!.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle.secondary(
              text: widget.experienceItem.isEvent ? 'À propos' : 'Présentation',
            ),

            SizedBox(height: AppDimensions.spacingXxxs),

            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: _buildCollapsedDescription(context, details.description!),
              secondChild: _buildExpandedDescription(context, details.description!),
            ),
          ],
        );
      },
    );
  }

  // ✅ Reste identique à l'original
  Widget _buildCollapsedDescription(BuildContext context, String description) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: AppTypography.body(isDark: isDark),
          maxLines: _maxLines,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppDimensions.spacingXxs),
        GestureDetector(
          onTap: () => setState(() => _expanded = true),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Voir plus',
                style: AppTypography.button(isDark: isDark).copyWith(
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: AppDimensions.spacingXxxs),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primary,
                size: AppDimensions.iconSizeS,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedDescription(BuildContext context, String description) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: AppTypography.body(isDark: isDark),
          maxLines: _expandedMaxLines,
        ),
        SizedBox(height: AppDimensions.spacingXxs),
        GestureDetector(
          onTap: () => setState(() => _expanded = false),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Voir moins',
                style: AppTypography.button(isDark: isDark).copyWith(
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: AppDimensions.spacingXxxs),
              Icon(
                Icons.keyboard_arrow_up,
                color: AppColors.primary,
                size: AppDimensions.iconSizeS,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre skeleton
        Container(
          width: 120,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.neutral300,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
        SizedBox(height: AppDimensions.spacingS),
        // Lignes de texte skeleton
        ...List.generate(
          4,
              (index) => Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.spacingXxs),
            child: Container(
              width: double.infinity,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.neutral300,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          ),
        ),
      ],
    );
  }
}