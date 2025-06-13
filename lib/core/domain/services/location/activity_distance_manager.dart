// lib/core/domain/services/location/activity_distance_manager.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:async/async.dart';
import '../../models/location/user_location.dart';
import '../../ports/search/activity_distance_calculation_port.dart';
import '../../ports/location/activity_distance_manager_port.dart';
import '../../services/location/enhanced_location_service.dart';
import '../../../common/utils/maps_toolkit_utils.dart';

/// Service centralisé pour la gestion des distances d'activités
///
/// Responsabilités :
/// - Position de référence unifiée (ville → GPS fallback)
/// - Cache intelligent et optimisé
/// - API générique découplée
/// - Invalidation automatique
class ActivityDistanceManager implements ActivityDistanceManagerPort {
  final ActivityDistanceCalculationPort _distanceCalculator;
  final EnhancedLocationService _locationService;

  // Cache des distances par activité
  final Map<String, double> _activityDistanceCache = {};

  // Cache de la position de référence
  LatLng? _cachedReferencePosition;
  DateTime? _referencePositionTimestamp;

  // Configuration cache
  static const Duration _referencePositionTtl = Duration(minutes: 15);
  static const double _roadDistanceFactor = 1.3;

  ActivityDistanceManager(
      this._distanceCalculator,
      this._locationService,
      );

  /// Récupère la distance d'une activité avec cache optimisé
  ///
  /// [activityId] : ID unique de l'activité
  /// [activityLat] : Latitude de l'activité
  /// [activityLon] : Longitude de l'activité
  /// [referencePosition] : Position de référence optionnelle (ville sélectionnée)
  Future<double?> getActivityDistance({
    required String activityId,
    required double activityLat,
    required double activityLon,
    LatLng? referencePosition,
  }) async {
    try {
      // Vérifier le cache d'abord
      if (_activityDistanceCache.containsKey(activityId)) {
        return _activityDistanceCache[activityId];
      }

      // Obtenir la position de référence
      final refPos = referencePosition ?? await getReferencePosition();
      if (refPos == null) return null;

      // Calculer la distance
      final distance = await _calculateDistance(
        from: refPos,
        to: LatLng(activityLat, activityLon),
      );

      // Mettre en cache
      if (distance != null) {
        _activityDistanceCache[activityId] = distance;
      }

      return distance;
    } catch (e) {
      print('❌ Erreur calcul distance activité $activityId: $e');
      return null;
    }
  }

  /// Calcule la distance depuis la position de référence (usage générique)
  ///
  /// [targetLat] : Latitude destination
  /// [targetLon] : Longitude destination
  Future<double?> calculateDistanceFromReference({
    required double targetLat,
    required double targetLon,
    LatLng? referencePosition,
  }) async {
    try {
      final refPos = referencePosition ?? await getReferencePosition();
      if (refPos == null) return null;

      return await _calculateDistance(
        from: refPos,
        to: LatLng(targetLat, targetLon),
      );
    } catch (e) {
      print('❌ Erreur calcul distance générique: $e');
      return null;
    }
  }

  /// Obtient la position de référence centralisée
  ///
  /// Priorité : Position ville sélectionnée → GPS utilisateur
  Future<LatLng?> getReferencePosition() async {
    try {
      // Vérifier le cache avec TTL
      if (_cachedReferencePosition != null && _referencePositionTimestamp != null) {
        final age = DateTime.now().difference(_referencePositionTimestamp!);
        if (age < _referencePositionTtl) {
          return _cachedReferencePosition;
        }
      }

      // Note: La position de ville sera injectée via le provider
      // Pour l'instant, fallback sur GPS
      final locationResult = await _locationService.getCurrentLocation();

      // Gérer le Result pattern
      if (locationResult.isError) {
        print('❌ Erreur GPS: ${locationResult.asError!.error}');
        return null;
      }

      final userLocation = locationResult.asValue!.value;
      final referencePos = LatLng(userLocation.latitude, userLocation.longitude);

      // Mettre en cache
      _cachedReferencePosition = referencePos;
      _referencePositionTimestamp = DateTime.now();

      return referencePos;
    } catch (e) {
      print('❌ Erreur récupération position de référence: $e');
      return null;
    }
  }

  /// Calcule la distance entre deux points avec facteur de correction routière
  Future<double?> _calculateDistance({
    required LatLng from,
    required LatLng to,
  }) async {
    try {
      // Calcul distance à vol d'oiseau
      final rawDistance = MapsToolkitUtils.calculateHaversineDistance(from, to);

      // Application du facteur de correction routière
      final correctedDistance = rawDistance * _roadDistanceFactor;

      return correctedDistance;
    } catch (e) {
      print('❌ Erreur calcul distance: $e');
      return null;
    }
  }

  /// Invalide tout le cache des distances
  void invalidateCache() {
    _activityDistanceCache.clear();
    _cachedReferencePosition = null;
    _referencePositionTimestamp = null;

    // Nettoyer aussi le cache du service sous-jacent
    _distanceCalculator.clearCache();

    print('🗑️ Cache distances invalidé');
  }

  /// Invalide le cache d'une activité spécifique
  void clearActivityCache(String activityId) {
    _activityDistanceCache.remove(activityId);
    print('🗑️ Cache distance activité $activityId supprimé');
  }

  /// Invalide le cache de position de référence
  ///
  /// Utile quand la ville sélectionnée change
  void invalidateReferencePosition() {
    _cachedReferencePosition = null;
    _referencePositionTimestamp = null;

    // Invalider aussi le cache des activités car la référence a changé
    _activityDistanceCache.clear();

    print('🗑️ Position de référence invalidée');
  }

  /// Pré-calcule les distances pour un lot d'activités
  ///
  /// Optimisation pour les listes/carousels
  Future<Map<String, double>> batchCalculateDistances({
    required List<({String id, double lat, double lon})> activities,
    LatLng? referencePosition,
  }) async {
    final results = <String, double>{};

    try {
      final refPos = referencePosition ?? await getReferencePosition();
      if (refPos == null) return results;

      for (final activity in activities) {
        // Vérifier le cache d'abord
        if (_activityDistanceCache.containsKey(activity.id)) {
          results[activity.id] = _activityDistanceCache[activity.id]!;
          continue;
        }

        // Calculer si pas en cache
        final distance = await _calculateDistance(
          from: refPos,
          to: LatLng(activity.lat, activity.lon),
        );

        if (distance != null) {
          results[activity.id] = distance;
          _activityDistanceCache[activity.id] = distance;
        }
      }

      print('📊 Batch distances calculées: ${results.length}/${activities.length}');
    } catch (e) {
      print('❌ Erreur batch calcul distances: $e');
    }

    return results;
  }

  /// Statistiques du cache (debug)
  Map<String, dynamic> getCacheStats() {
    return {
      'activityCacheSize': _activityDistanceCache.length,
      'hasReferencePosition': _cachedReferencePosition != null,
      'referencePositionAge': _referencePositionTimestamp != null
          ? DateTime.now().difference(_referencePositionTimestamp!).inMinutes
          : null,
    };
  }
}