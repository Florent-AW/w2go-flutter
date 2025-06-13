// lib/features/shared_ui/presentation/templates/city_picker_template.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/components/organisms/city_picker_content.dart';
import '../../../../core/theme/components/molecules/search_results_list.dart';
import '../../../../core/domain/models/search/recent_city.dart';
import '../../../../core/domain/models/shared/city_model.dart';

/// Template de la page de sélection de ville
/// S'occupe principalement de la structure de la page et de la navigation
class CityPickerTemplate extends ConsumerWidget {
  /// Callback quand une ville est sélectionnée
  final void Function(City) onCitySelected;

  /// Callback pour le bouton retour
  final VoidCallback onBackPressed;

  /// Liste des recherches récentes
  final List<RecentCity> recentCities;

  /// Liste des villes suggérées
  final List<City> suggestedCities;

  /// État initial des résultats de recherche
  final SearchResultsState initialResultsState;

  /// Ville actuellement sélectionnée
  final City? selectedCity;

  /// Fonction de recherche
  final Future<List<City>> Function(String) onSearch;

  /// Indique si une recherche est en cours
  final bool isSearching;

  const CityPickerTemplate({
    Key? key,
    required this.onCitySelected,
    required this.onBackPressed,
    required this.recentCities,
    required this.suggestedCities,
    required this.onSearch,
    this.initialResultsState = SearchResultsState.initial,
    this.selectedCity,
    this.isSearching = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // Pas d'AppBar traditionnel, nous utilisons notre propre en-tête
      body: SafeArea(
        child: CityPickerContent(
          onCitySelected: onCitySelected,
          onBackPressed: onBackPressed,
          recentCities: recentCities,
          suggestedCities: suggestedCities,
          initialResultsState: initialResultsState,
          selectedCity: selectedCity,
          onSearch: onSearch,
        ),
      ),
    );
  }
}