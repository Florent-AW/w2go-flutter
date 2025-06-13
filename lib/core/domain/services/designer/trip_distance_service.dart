// lib/core/domain/services/distance_service.dart

import '../../../common/utils/maps_toolkit_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DistanceService {
  // Cache des distances calculées
  final Map<String, double> _distanceCache = {};

  // Clé de cache combinant l'ID de l'activité et la position utilisateur
  String _getCacheKey(String activityId, LatLng userLocation) {
    return '$activityId-${userLocation.latitude}-${userLocation.longitude}';
  }

  double getDistance({
    required String activityId,
    required LatLng userLocation,
    required LatLng activityLocation,
    double? approximateDistance,
  }) {
    final cacheKey = _getCacheKey(activityId, userLocation);

    // Vérifier le cache d'abord
    if (_distanceCache.containsKey(cacheKey)) {
      return _distanceCache[cacheKey]!;
    }

    // Sinon calculer la distance précise
    final distance = MapsToolkitUtils.calculateHaversineDistance(
      userLocation,
      activityLocation,
    );

    // Mettre en cache
    _distanceCache[cacheKey] = distance;

    return distance;
  }
}