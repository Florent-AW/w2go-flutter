// lib/features/experience_detail/presentation/organisms/experience_intro_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../features/shared_ui/presentation/widgets/atoms/event_date_badge.dart';
import '../../application/providers/experience_detail_providers.dart';
import '../molecules/experience_title_info.dart';


/// Section intro unifiée pour Activities + Events
class ExperienceIntroSection extends ConsumerWidget {
  final ExperienceItem experienceItem;

  // ✅ Données immédiates pour fallback (navigation)
  final String? immediateTitle;
  final String? immediateCity;
  final String? immediateCategoryName;
  final String? immediateSubcategoryName;
  final String? immediateSubcategoryIcon;

  const ExperienceIntroSection({
    Key? key,
    required this.experienceItem,
    this.immediateTitle,
    this.immediateCity,
    this.immediateCategoryName,
    this.immediateSubcategoryName,
    this.immediateSubcategoryIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(experienceDetailProvider(experienceItem));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Badge de date pour les événements (avant le titre)
        if (experienceItem.isEvent && experienceItem.startDate != null)
          Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.spacingS),
            child: EventDateBadge(
              startDate: experienceItem.startDate!,
              endDate: experienceItem.endDate,
            ),
          ),

        // ✅ Titre unifié Activities + Events via ExperienceTitleInfo
        detailState.when(
          initial: () => _buildUnifiedTitleInfo(null),
          loading: () => _buildUnifiedTitleInfo(null),
          error: (_) => _buildUnifiedTitleInfo(null),
          loaded: (details) => _buildUnifiedTitleInfo(details),
        ),
      ],
    );
  }

  /// ✅ NOUVEAU : Composant unifié remplace la logique Activities vs Events
  Widget _buildUnifiedTitleInfo(details) {
    return ExperienceTitleInfo(
      experienceItem: experienceItem,
      details: details,
      fallbackTitle: immediateTitle,
      fallbackCity: immediateCity,
      fallbackCategoryName: immediateCategoryName,
      fallbackSubcategoryName: immediateSubcategoryName,
      fallbackSubcategoryIcon: immediateSubcategoryIcon,
    );
  }
}