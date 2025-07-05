// lib/core/domain/ports/providers/search/activity_distance_manager_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../location/activity_distance_manager_port.dart';
import '../../../services/location/activity_distance_manager.dart';
import '../../../models/shared/city_model.dart';
import '../../../../../features/search/application/state/city_selection_state.dart';
import '../location/location_providers.dart';
import '../../../ports/providers/search/distance_providers.dart';

/// Provider principal pour ActivityDistanceManager
///
/// Injecte toutes les dépendances nécessaires :
/// - ActivityDistanceCalculationPort (service calcul existant)
/// - EnhancedLocationService (service géolocalisation)
final activityDistanceManagerProvider = Provider<ActivityDistanceManagerPort>((ref) {
  final enhancedLocationService = ref.watch(enhancedLocationServiceProvider);
  final distanceCalculator = ref.read(activityDistanceProvider);  // ✅ Utiliser le provider existant
  return ActivityDistanceManager(distanceCalculator, enhancedLocationService);
});

/// Provider pour la position de référence intelligente
///
/// Intègre avec selectedCityProvider existant
/// Logique : Ville sélectionnée → GPS fallback
final referencePositionProvider = FutureProvider<LatLng?>((ref) async {
  final distanceManager = ref.watch(activityDistanceManagerProvider);
  final selectedCity = ref.watch(selectedCityProvider);

  // Priorité 1: Ville sélectionnée
  if (selectedCity != null) {
    return LatLng(selectedCity.lat, selectedCity.lon);
  }

  // Priorité 2: GPS via le manager (avec cache TTL)
  return await distanceManager.getReferencePosition();
});

/// ✅ API PUBLIQUE FINALE - Provider pour les distances d'activités
///
/// Système centralisé unifié pour toute l'application
final activityDistancesProvider = StateNotifierProvider<ActivityDistancesNotifier, Map<String, double>>((ref) {
  final distanceManager = ref.watch(activityDistanceManagerProvider);
  final selectedCity = ref.watch(selectedCityProvider);
  final cityPosition = selectedCity != null
      ? (lat: selectedCity.lat, lon: selectedCity.lon)
      : null;

  return ActivityDistancesNotifier(distanceManager, cityPosition, ref);
});

/// ✅ Notifier unifié pour la gestion des distances
///
/// Remplace l'ancien système par une approche centralisée
class ActivityDistancesNotifier extends StateNotifier<Map<String, double>> {
  final ActivityDistanceManagerPort _distanceManager;
  final ({double lat, double lon})? _cityPosition;
  final Ref _ref;

  ActivityDistancesNotifier(this._distanceManager, this._cityPosition, this._ref) : super({});

  /// Calcule et cache les distances pour un lot d'activités
  ///
  /// API compatible avec l'ancienne méthode cacheDistances
  Future<void> cacheActivitiesDistances(List<({String id, double lat, double lon})> activities) async {
    try {
      if (_cityPosition == null) {
        print('⚠️ Position de référence indisponible pour calcul distances');
        return;
      }

      final refPos = LatLng(_cityPosition!.lat, _cityPosition!.lon);

      // Calcul batch optimisé
      final distances = await _distanceManager.batchCalculateDistances(
        activities: activities,
        referencePosition: refPos,
      );

      // Mise à jour de l'état
      state = {...state, ...distances};

      if (distances.isNotEmpty) {
      }
    } catch (e) {
      print('❌ Erreur cache distances batch: $e');
    }
  }

  /// Récupère la distance d'une activité spécifique
  Future<double?> getActivityDistance({
    required String activityId,
    required double activityLat,
    required double activityLon,
  }) async {
    try {
      // Vérifier le cache local d'abord
      if (state.containsKey(activityId)) {
        return state[activityId];
      }

      if (_cityPosition == null) {
        print('⚠️ DISTANCE: Aucune ville sélectionnée pour calculer la distance');
        return null;
      }

      // Calculer via le manager avec position ville
      final distance = await _distanceManager.getActivityDistance(
        activityId: activityId,
        activityLat: activityLat,
        activityLon: activityLon,
        referencePosition: LatLng(_cityPosition!.lat, _cityPosition!.lon),
      );

      // Mettre à jour le cache local si calculé
      if (distance != null) {
        state = {...state, activityId: distance};
      }

      return distance;
    } catch (e) {
      print('❌ Erreur récupération distance activité $activityId: $e');
      return null;
    }
  }

  /// Récupère une distance depuis le cache (API existante)
  double? getDistance(String activityId) => state[activityId];

  /// Invalide tout le cache
  void clearCache() {
    _distanceManager.invalidateCache();
    state = {};
    print('🗑️ Cache distances unifié vidé');
  }

  /// Invalide le cache quand la position de référence change
  void invalidateOnReferenceChange() {
    _distanceManager.invalidateReferencePosition();
    state = {};
    print('🔄 Cache invalidé suite changement position référence');
  }
}

/// Provider helper pour écouter les changements de ville
///
/// Invalide automatiquement le cache des distances quand la ville change
final cityChangeListener = Provider<void>((ref) {
  final selectedCity = ref.watch(selectedCityProvider);
  final distanceNotifier = ref.watch(activityDistancesProvider.notifier);

  // Écouter les changements de ville et invalider le cache
  ref.listen<City?>(
    selectedCityProvider,
        (previous, next) {
      if (previous != next && next != null) {
        print('🏙️ Ville changée vers "${next.cityName}" - invalidation cache distances');
        distanceNotifier.invalidateOnReferenceChange();
      }
    },
  );
});

/// Provider pour statistiques du cache (debug/monitoring)
final distanceCacheStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final distanceManager = ref.watch(activityDistanceManagerProvider);
  final localCacheSize = ref.watch(activityDistancesProvider).length;
  final selectedCity = ref.watch(selectedCityProvider);

  final managerStats = distanceManager.getCacheStats();

  return {
    ...managerStats,
    'localStateCache': localCacheSize,
    'totalCacheSize': managerStats['activityCacheSize'] + localCacheSize,
    'selectedCityName': selectedCity?.cityName,
    'selectedCityCoords': selectedCity != null ? '${selectedCity.lat}, ${selectedCity.lon}' : null,
  };
});