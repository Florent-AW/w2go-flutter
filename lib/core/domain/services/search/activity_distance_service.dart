// lib/core/domain/services/search/activity_distance_service.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../ports/search/activity_distance_calculation_port.dart';
import '../../../common/utils/maps_toolkit_utils.dart';

class ActivityDistanceService implements ActivityDistanceCalculationPort {
  final Map<String, double> _distanceCache = {};

  String _getCacheKey(String activityId, LatLng userLocation) {
    return '$activityId-${userLocation.latitude}-${userLocation.longitude}';
  }

  // Ajout d'une constante pour le facteur de correction
  static const double ROAD_DISTANCE_FACTOR = 1.3;

  @override
  double calculateDistance({
    required String activityId,
    required LatLng userLocation,
    required LatLng activityLocation,
    double? approximateDistance,
  }) {
    final cacheKey = _getCacheKey(activityId, userLocation);

    if (_distanceCache.containsKey(cacheKey)) {
      return _distanceCache[cacheKey]!;
    }

    final rawDistance = MapsToolkitUtils.calculateHaversineDistance(
      userLocation,
      activityLocation,
    );

    // Application du facteur de correction
    final correctedDistance = rawDistance * ROAD_DISTANCE_FACTOR;

    _distanceCache[cacheKey] = correctedDistance;
    return correctedDistance;
  }

  @override
  void clearCache() {
    _distanceCache.clear();
  }
}