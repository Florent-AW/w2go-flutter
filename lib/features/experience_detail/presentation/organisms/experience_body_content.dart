// lib/features/experience_detail/presentation/organisms/experience_body_content.dart

import 'package:flutter/material.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/theme/app_dimensions.dart';
import 'experience_intro_section.dart';
import 'experience_info_section.dart';
import 'experience_description_panel.dart';
import 'activity_recommendations_section.dart';

/// ✅ ORGANISM : Contenu du corps de la page de détail
class ExperienceBodyContent extends StatelessWidget {
  final ExperienceItem experienceItem;

  const ExperienceBodyContent({
    Key? key,
    required this.experienceItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ ORGANISM : Section intro
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingM,
          ),
          child: ExperienceIntroSection(
            experienceItem: experienceItem,
            immediateTitle: experienceItem.name,
            immediateCity: experienceItem.city,
            immediateCategoryName: experienceItem.categoryName,
            immediateSubcategoryName: experienceItem.subcategoryName,
            immediateSubcategoryIcon: experienceItem.subcategoryIcon,
          ),
        ),

        // ✅ ORGANISM : Section info
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingXs,
          ),
          child: ExperienceInfoSection(
            experienceItem: experienceItem,
          ),
        ),

        // ✅ ORGANISM : Section description
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingM,
          ),
          child: ExperienceDescriptionPanel(
            experienceItem: experienceItem,
          ),
        ),

        // ✅ ORGANISM : Recommandations (Activities seulement)
        if (!experienceItem.isEvent)
          ActivityRecommendationsSection(
            activityId: experienceItem.id,
            openBuilder: null,
          ),

        // ✅ Bottom space for floating action bar
        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 100,
        ),
      ],
    );
  }
}