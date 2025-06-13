// lib/core/theme/components/molecules/recent_cities_list.dart

import 'package:flutter/material.dart';
import '../../app_dimensions.dart';
import '../atoms/city_list_item.dart';
import '../atoms/section_title.dart';
import '../atoms/city_divider.dart';
import '../../../domain/models/search/recent_city.dart';
import '../../../domain/models/shared/city_model.dart';

/// Liste des villes récemment recherchées
/// Combine des atomes pour former un composant réutilisable
class RecentCitiesList extends StatelessWidget {
  /// Liste des villes récentes à afficher
  final List<RecentCity> recentCities;

  /// Callback appelé quand une ville est sélectionnée
  final void Function(City) onCitySelected;

  /// Afficher le titre de section
  final bool showTitle;

  /// Ville actuellement sélectionnée
  final City? selectedCity;

  const RecentCitiesList({
    Key? key,
    required this.recentCities,
    required this.onCitySelected,
    this.showTitle = true,
    this.selectedCity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recentCities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Titre de section
        if (showTitle)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.space4),
            child: const SectionTitle.secondary(
              text: 'Recherches récentes',
            ),
          ),

        // Liste des villes récentes
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.space4),
          itemCount: recentCities.length,
          separatorBuilder: (context, index) => const CityDivider.subtle(),
          itemBuilder: (context, index) {
            final city = recentCities[index].city;
            final isSelected = selectedCity?.id == city.id;

            return CityListItem.history(
              city: city,
              isSelected: isSelected,
              onTap: () => onCitySelected(city),
            );
          },
        ),

        // Séparateur de section
        const CityDivider(),
      ],
    );
  }
}