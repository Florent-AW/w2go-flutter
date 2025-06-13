// lib/features/search/application/state/place_search_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:async/async.dart';
import '../../../../core/domain/models/location/place_suggestion.dart';
import '../../../../core/domain/services/location/enhanced_location_service.dart';
import '../../../../core/domain/ports/providers/location/location_providers.dart';
import '../../../../core/common/exceptions/location_exceptions.dart';
import 'place_search_state.dart';

class PlaceSearchNotifier extends StateNotifier<PlaceSearchState> {
  final EnhancedLocationService _locationService;
  String _lastQuery = ''; // Mémoriser la dernière requête pour l'idempotence

  PlaceSearchNotifier(this._locationService)
      : super(const PlaceSearchState.initial());

  /// Recherche des lieux - méthode idempotente
  void searchLocation(String query) {
    // Ne recherche que si la requête est différente
    // Vérifier si c'est la même requête et si l'état n'est pas loading
    if (query == _lastQuery && !state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    )) {
      return; // Évite les recherches redondantes
    }

    _lastQuery = query;

    if (query.isEmpty) {
      state = const PlaceSearchState.initial();
      return;
    }

    if (query.length < 3) {
      state = const PlaceSearchState.noResults();
      return;
    }

    state = const PlaceSearchState.loading();

    _locationService.searchPlacesWithDebounce(
      query,
          (Result<List<PlaceSuggestion>> result) {
        // Vérifie si la requête est toujours pertinente
        if (_lastQuery != query) {
          return; // Ignore les résultats obsolètes
        }

        if (result.isError) {
          state = PlaceSearchState.error(
              result.asError!.error.toString()
          );
          return;
        }

        final suggestions = result.asValue!.value;

        if (suggestions.isEmpty) {
          state = const PlaceSearchState.noResults();
        } else {
          state = PlaceSearchState.loaded(suggestions);
        }
      },
    );
  }

  /// Annule la recherche en cours - méthode idempotente
  void cancelSearch() {
    _locationService.cancelSearch();

    // Ne change l'état que si nécessaire (vérifie s'il est déjà initial)
    state.maybeWhen(
      initial: () => {}, // Ne rien faire si déjà initial
      orElse: () {
        state = const PlaceSearchState.initial();
        _lastQuery = '';
      },
    );
  }

  /// Réinitialise l'état - méthode idempotente
  void reset() {
    cancelSearch();
  }
}

// Provider pour le notifier
final placeSearchNotifierProvider = StateNotifierProvider<PlaceSearchNotifier, PlaceSearchState>((ref) {
  final locationService = ref.watch(enhancedLocationServiceProvider);
  return PlaceSearchNotifier(locationService);
});

/// Selector pour n'observer que les suggestions
final placeSuggestionsProvider = Provider<List<PlaceSuggestion>>((ref) {
  return ref.watch(placeSearchNotifierProvider).maybeWhen(
    loaded: (suggestions) => suggestions,
    orElse: () => [],
  );
});

/// Selector pour l'état de chargement
final isSearchingPlacesProvider = Provider<bool>((ref) {
  return ref.watch(placeSearchNotifierProvider).maybeWhen(
    loading: () => true,
    orElse: () => false,
  );
});

/// Selector pour vérifier si la recherche est vide
final hasNoResultsProvider = Provider<bool>((ref) {
  return ref.watch(placeSearchNotifierProvider).maybeWhen(
    noResults: () => true,
    orElse: () => false,
  );
});

/// Selector pour récupérer un message d'erreur le cas échéant
final searchErrorMessageProvider = Provider<String?>((ref) {
  return ref.watch(placeSearchNotifierProvider).maybeWhen(
    error: (message) => message,
    orElse: () => null,
  );
});