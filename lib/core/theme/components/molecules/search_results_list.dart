// lib/core/theme/components/molecules/search_results_list.dart

import 'package:flutter/material.dart';
import '../../app_dimensions.dart';
import '../../app_colors.dart';
import '../../app_typography.dart';
import '../atoms/city_list_item.dart';
import '../../../domain/models/shared/city_model.dart';

/// États possibles des résultats de recherche
enum SearchResultsState {
  /// Pas de recherche effectuée
  initial,

  /// En cours de chargement
  loading,

  /// Résultats disponibles
  results,

  /// Aucun résultat trouvé
  empty,

  /// Erreur lors de la recherche
  error
}

/// Liste des résultats de recherche
/// Combine des atomes pour former une molécule
class SearchResultsList extends StatelessWidget {
  /// État actuel des résultats
  final SearchResultsState state;

  /// Liste des villes trouvées
  final List<City> cities;

  /// Requête de recherche
  final String query;

  /// Callback appelé quand une ville est sélectionnée
  final void Function(City) onCitySelected;

  /// Message d'erreur (si état == error)
  final String? errorMessage;

  /// Ville actuellement sélectionnée
  final City? selectedCity;

  const SearchResultsList({
    Key? key,
    required this.state,
    required this.cities,
    required this.query,
    required this.onCitySelected,
    this.errorMessage,
    this.selectedCity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (state) {
      case SearchResultsState.initial:
      // Aucune recherche effectuée
        return const SizedBox.shrink();

      case SearchResultsState.loading:
      // Indicateur de chargement
        return Center(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space6),
            child: const CircularProgressIndicator(),
          ),
        );

      case SearchResultsState.results:
      // Liste des résultats
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppDimensions.space4),
          itemCount: cities.length,
          itemBuilder: (context, index) {
            final city = cities[index];
            final isSelected = selectedCity?.id == city.id;

            return Padding(
              padding: EdgeInsets.only(bottom: AppDimensions.space3),
              child: CityListItem(
                city: city,
                isSelected: isSelected,
                onTap: () => onCitySelected(city),
              ),
            );
          },
        );

      case SearchResultsState.empty:
      // Aucun résultat trouvé
        return Center(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off,
                  size: 48,
                  color: isDark ? AppColors.neutral500 : AppColors.neutral400,
                ),
                SizedBox(height: AppDimensions.space4),
                Text(
                  'Aucune ville trouvée pour "$query"',
                  style: AppTypography.body(
                    isDark: isDark,
                    isSecondary: true,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );

      case SearchResultsState.error:
      // Affichage de l'erreur
        return Center(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                SizedBox(height: AppDimensions.space4),
                Text(
                  errorMessage ?? 'Une erreur est survenue',
                  style: AppTypography.body(
                    isDark: isDark,
                    isSecondary: true,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
    }
  }
}