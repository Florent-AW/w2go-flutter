// lib/features/shared_ui/presentation/pages/city_picker_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../../core/domain/ports/providers/search/recent_cities_provider.dart';
import '../../../../core/domain/ports/providers/search/suggested_cities_provider.dart';
import '../../../../core/domain/ports/providers/location/location_providers.dart';
import '../../../../core/theme/components/molecules/search_results_list.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../../search/application/state/city_picker_view_model.dart';
import '../../../search/application/state/city_picker_state.dart';
import '../templates/city_picker_template.dart';


class CityPickerPage extends ConsumerStatefulWidget {
  /// Callback optionnel lorsqu'une ville est sélectionnée
  final Function(City)? onCitySelected;

  /// Callback optionnel pour la fermeture manuelle
  final VoidCallback? onClose;

  const CityPickerPage({
    Key? key,
    this.onCitySelected,
    this.onClose,
  }) : super(key: key);

  /// Méthode utilitaire pour ouvrir la page et récupérer la ville sélectionnée
  static Future<City?> open(BuildContext context) {
    return Navigator.of(context).push<City>(
      MaterialPageRoute(
        builder: (context) => const CityPickerPage(),
      ),
    );
  }

  @override
  ConsumerState<CityPickerPage> createState() => _CityPickerPageState();
}

class _CityPickerPageState extends ConsumerState<CityPickerPage> {

  @override
  Widget build(BuildContext context) {
    // Observer l'état de la sélection de ville
    final cityPickerState = ref.watch(cityPickerViewModelProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    ref.listen<CityPickerState>(
        cityPickerViewModelProvider, (previous, current) {
      final selectedCity = current.maybeWhen(
        loaded: (_, __, selected) => selected,
        orElse: () => null,
      );

      if (selectedCity != null) {
        // Propager la sélection
        ref.read(selectedCityProvider.notifier).selectCity(selectedCity);
        // Ajouter aux recherches récentes
        ref.read(recentCitiesNotifierProvider.notifier).addCity(selectedCity);
      }
    });

    // Récupérer les recherches récentes
    final recentCitiesState = ref.watch(recentCitiesNotifierProvider);

    // Récupérer les suggestions de villes
    final suggestedCitiesState = ref.watch(suggestedCitiesProvider);


    // Transformer l'état du provider en état d'affichage
    SearchResultsState resultsState = SearchResultsState.initial;

    resultsState = cityPickerState.maybeWhen(
      initial: () => SearchResultsState.initial,
      loading: () => SearchResultsState.loading,
      loaded: (cities, query, _) {
        if (cities.isEmpty && query.isNotEmpty) {
          return SearchResultsState.empty;
        } else if (cities.isNotEmpty) {
          return SearchResultsState.results;
        }
        return SearchResultsState.initial;
      },
      error: (_) => SearchResultsState.error,
      orElse: () => SearchResultsState.initial,
    );

    return CityPickerTemplate(
      onCitySelected: (city) {
        // Mettre à jour le provider de sélection
        ref.read(selectedCityProvider.notifier).selectCity(city);

        // Ajouter aux recherches récentes
        ref.read(recentCitiesNotifierProvider.notifier).addCity(city);

        // Navigation directe ou callback
        if (widget.onCitySelected != null) {
          widget.onCitySelected!(city);
        } else {
          Navigator.of(context).pop(city);
        }
      },
      onBackPressed: () {
        // Retourner la ville sélectionnée si disponible
        if (widget.onClose != null) {
          widget.onClose!();
        } else {
          Navigator.of(context).pop(selectedCity);
        }
      },
      recentCities: recentCitiesState.when(
        data: (cities) => cities,
        loading: () => [],
        error: (_, __) => [],
      ),
      suggestedCities: suggestedCitiesState.when(
        data: (cities) => cities,
        loading: () => [],
        error: (_, __) => [],
      ),
      initialResultsState: resultsState,
      selectedCity: selectedCity,
      onSearch: (query) async {
        await ref.read(cityPickerViewModelProvider.notifier).searchCities(query);

        final state = ref.read(cityPickerViewModelProvider);
        return state.maybeWhen(
          loaded: (cities, _, __) => cities,
          orElse: () => [],
        );
      },
    );
  }
}
