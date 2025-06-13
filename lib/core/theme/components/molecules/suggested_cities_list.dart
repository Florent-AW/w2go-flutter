// lib/core/theme/components/molecules/suggested_cities_list.dart

import 'package:flutter/material.dart';
import '../../app_dimensions.dart';
import '../atoms/city_list_item.dart';
import '../atoms/section_title.dart';
import '../atoms/city_divider.dart'; // Ajout du divider
import '../../../domain/models/shared/city_model.dart';

/// Affichage des villes suggérées sous forme de liste
/// Utilise les atomes CityListItem et SectionTitle
class SuggestedCitiesList extends StatelessWidget {
  /// Liste des villes suggérées à afficher
  final List<City> suggestedCities;

  /// Callback appelé quand une ville est sélectionnée
  final void Function(City) onCitySelected;

  /// Ville actuellement sélectionnée
  final City? selectedCity;

  const SuggestedCitiesList({
    Key? key,
    required this.suggestedCities,
    required this.onCitySelected,
    this.selectedCity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (suggestedCities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Titre de section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.space4),
          child: const SectionTitle.secondary(
            text: 'Suggestions',
          ),
        ),

        // Liste des villes suggérées (format vertical uniforme)
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.space4),
          itemCount: suggestedCities.length,
          separatorBuilder: (context, index) => const CityDivider.subtle(),
          itemBuilder: (context, index) {
            final city = suggestedCities[index];
            final isSelected = selectedCity?.id == city.id;

            // Formatage du texte secondaire (code postal + département)
            String? secondaryText;
            if (city.postalCode != null && city.department != null) {
              secondaryText = "${city.postalCode} - ${city.department}";
            } else if (city.postalCode != null) {
              secondaryText = city.postalCode;
            } else if (city.department != null) {
              secondaryText = city.department;
            }

            return CityListItem(
              city: city,
              isSelected: isSelected,
              secondaryText: secondaryText,
              onTap: () => onCitySelected(city),
            );
          },
        ),

      ],
    );
  }
}