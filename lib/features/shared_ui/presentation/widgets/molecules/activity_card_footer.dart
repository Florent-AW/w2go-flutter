// lib/features/shared_ui/presentation/widgets/molecules/activity_card_footer.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/components/atoms/location_info.dart';
import '../../../../../core/theme/components/atoms/activity_distance_badge.dart';
import '../atoms/activity_tag.dart';
import 'activity_category_label.dart';

class ActivityCardFooter extends StatelessWidget {
  final String title;
  final String city;
  final String category;
  final String? subcategoryName;
  final String? subcategoryIcon;
  final double? distance;
  final List<String> tags;
  final bool showSubcategory;
  final bool showDistance;

  const ActivityCardFooter({
    Key? key,
    required this.title,
    required this.city,
    required this.category,
    this.subcategoryName,
    this.subcategoryIcon,
    this.distance,
    this.tags = const [],
    this.showSubcategory = true,
    this.showDistance = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.spacingXxxs,
        right: AppDimensions.spacingXxxs,
        top: AppDimensions.spacingXs,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Afficher la sous-catégorie conditionnellement
        if (showSubcategory)
          ActivityCategoryLabel(
            category: category,
            subcategoryIcon: subcategoryIcon,
            subcategoryName: subcategoryName,
          ),

        // Espacement après sous-catégorie (seulement si elle existe)
        if (showSubcategory) SizedBox(height: AppDimensions.spacingXxxs), // 8px

        // Titre
        Text(
          title,
          style: AppTypography.titleXxs(isDark: false),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Espacement après titre
        SizedBox(height: AppDimensions.spacingXxs), // 8px

        // Tags (peuvent prendre plusieurs lignes maintenant)
        _buildTags(),

        // Espacement après tags
        SizedBox(height: AppDimensions.spacingXxs), // 8px

        // Prend l'espace disponible pour rapprocher le bas de la card
        const Spacer(),

        // Ville et distance sur la même ligne
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ✅ NOUVEAU : Utiliser l'atom LocationInfo
            Expanded(
              child: LocationInfo(
                city: city,
                iconSize: AppDimensions.iconSizeXs, // 12px pour les cards
              ),
            ),
            if (distance != null && showDistance)
              ActivityDistanceBadge(
                activityId: showDistance ? '' : 'no-distance', // ✅ ID invalide si pas d'affichage
                fallbackDistance: showDistance ? distance : null, // ✅ Double sécurité
              ),
          ],
        ),
      ],
    ),
    );
  }

  Widget _buildTags() {
    // En attendant les données réelles de Supabase
    final defaultTags = ['Activité en famille', 'Populaire'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: (tags.isEmpty ? defaultTags : tags).map((tag) =>
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: ActivityTag(label: tag),
            )
        ).toList(),
      ),
    );
  }


}