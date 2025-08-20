// lib/features/favorites/presentation/organisms/favorites_list_sectioned.dart

import 'package:flutter/material.dart';
import 'package:travel_in_perigord_app/core/theme/app_dimensions.dart';
import 'package:travel_in_perigord_app/core/theme/components/atoms/section_title.dart';
import 'package:travel_in_perigord_app/features/favorites/application/favorites_sections_provider.dart';
import 'package:travel_in_perigord_app/features/shared_ui/presentation/widgets/molecules/experience_card_with_favorite.dart';

class FavoritesListSectioned extends StatelessWidget {
  final List<FavoritesSection> sections;
  const FavoritesListSectioned({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final section in sections) ...[
          if (section.items.isNotEmpty) ...[
            SectionTitle.secondary(
              text: section.title,
              bottomSpacing: AppDimensions.spacingXs,
            ),
            ...section.items.map((item) => Padding(
                  key: ValueKey('fav_${item.id}'),
                  padding: EdgeInsets.only(bottom: AppDimensions.spacingXxxs),
                  child: ExperienceCardWithFavorite(
                    experience: item,
                    heroTag: 'fav_${item.id}',
                    showDistance: false,
                    showSubcategory: true,
                  ),
                )),
            SizedBox(height: AppDimensions.spacingS),
          ]
        ]
      ],
    );
  }
}
