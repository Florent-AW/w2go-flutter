// lib/core/domain/ports/search/activity_distance_calculation_port.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class ActivityDistanceCalculationPort {
  double calculateDistance({
    required String activityId,
    required LatLng userLocation,
    required LatLng activityLocation,
    double? approximateDistance,
  });

  // Facultatif : méthode pour nettoyer le cache si nécessaire
  void clearCache();
}