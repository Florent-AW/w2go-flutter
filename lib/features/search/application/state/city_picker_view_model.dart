// lib/features/search/application/state/city_picker_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import 'city_picker_state.dart';
import 'city_search_provider.dart';
import 'place_details_notifier.dart';
import 'city_selection_state.dart';

class CityPickerViewModel extends StateNotifier<CityPickerState> {
  final Ref _ref;
  final Map<String, List<City>> _queryCache = {};

  CityPickerViewModel(this._ref)
      : super(const CityPickerState.initial());

  /// Recherche des villes selon la requête utilisateur
  Future<void> searchCities(String query) async {
    // Conserver la ville sélectionnée lors d'une nouvelle recherche
    final currentSelected = state.maybeWhen(
      loaded: (_, __, selectedCity) => selectedCity,
      orElse: () => null,
    );

    if (query.isEmpty) {
      state = CityPickerState.loaded(
        cities: [],
        query: '',
        selectedCity: currentSelected, // Préserver la sélection
      );
      return;
    }

    if (_queryCache.containsKey(query)) {
      // Utiliser les résultats en cache
      state = CityPickerState.loaded(
        cities: _queryCache[query]!,
        query: query,
        selectedCity: currentSelected,
      );
      return;
    }

    state = const CityPickerState.loading();

    try {
      // Utiliser le provider existant pour la recherche de villes
      final cities = await _ref.read(citiesSearchResultsProvider(query).future);

      // Mettre en cache les résultats
      _queryCache[query] = cities;

      state = CityPickerState.loaded(
        cities: cities,
        query: query,
        selectedCity: currentSelected, // Préserver la sélection
      );

      print("🔍 DEBUG: Recherche terminée, ville sélectionnée préservée: ${currentSelected?.cityName}");
    } catch (e) {
      state = CityPickerState.error('Erreur lors de la recherche: $e');
    }
  }

  /// Sélectionne une ville
  void selectCity(City city) {
    // Récupérer les valeurs actuelles
    final prevCities = state.maybeWhen(
      loaded: (cities, _, __) => cities,
      orElse: () => <City>[],
    );

    final prevQuery = state.maybeWhen(
      loaded: (_, query, __) => query,
      orElse: () => '',
    );

    // Mettre à jour l'état local
    state = CityPickerState.loaded(
      cities: prevCities,
      query: prevQuery,
      selectedCity: city,
    );

    // Propager la sélection au provider global
    _ref.read(selectedCityProvider.notifier).selectCity(city);

    print("🔍 DEBUG: Ville sélectionnée: ${city.cityName}");
  }

  /// Obtient la position actuelle
  Future<void> getCurrentLocation() async {
    state = const CityPickerState.loading();

    try {
      // Utiliser le notifier existant pour la géolocalisation
      await _ref.read(placeDetailsNotifierProvider.notifier).getCurrentLocation();

      // Observer le résultat
      final placeDetailsState = _ref.read(placeDetailsNotifierProvider);

      placeDetailsState.whenOrNull(
          loaded: (details) {
            // Créer une City à partir des détails du lieu
            final city = City(
              id: details.placeId,
              cityName: details.name,
              lat: details.location.latitude,
              lon: details.location.longitude,
              geohash5: '', // À calculer si nécessaire
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            state = CityPickerState.loaded(
              cities: [city],
              query: '',
              selectedCity: city,
            );
          },
          error: (message) {
            state = CityPickerState.error(message);
          }
      );
    } catch (e) {
      state = CityPickerState.error('Erreur de géolocalisation: $e');
    }
  }

  /// Réinitialise l'état
  void reset() {
    // Ne réinitialise que si l'état n'est pas déjà initial
    state.maybeWhen(
      initial: () {}, // Ne rien faire si déjà initial
      orElse: () {
        state = const CityPickerState.initial();
      },
    );
  }
}

// Provider pour le view model
final cityPickerViewModelProvider = StateNotifierProvider.autoDispose<CityPickerViewModel, CityPickerState>((ref) {
  return CityPickerViewModel(ref);
});

/// Selector pour accéder uniquement à la ville sélectionnée
final pickerSelectedCityProvider = Provider.autoDispose<City?>((ref) {
  return ref.watch(cityPickerViewModelProvider).maybeWhen(
    loaded: (_, __, selectedCity) => selectedCity,
    orElse: () => null,
  );
});

/// Selector pour déterminer si une ville est sélectionnée (pour activer/désactiver la validation)
final canValidateCityProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(pickerSelectedCityProvider) != null;
});

/// Selector pour obtenir les villes filtrées actuelles
final filteredCitiesProvider = Provider.autoDispose<List<City>>((ref) {
  return ref.watch(cityPickerViewModelProvider).maybeWhen(
    loaded: (cities, _, __) => cities,
    orElse: () => [],
  );
});

/// Selector pour l'état de chargement
final isCitySearchLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(cityPickerViewModelProvider).maybeWhen(
    loading: () => true,
    orElse: () => false,
  );
});