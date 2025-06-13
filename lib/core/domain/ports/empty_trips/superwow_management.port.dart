// lib/core/domain/ports/empty_trips/superwow_management.port.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/scored_activity.dart';
import '../../models/trip_designer/empty_trips/value_objects/superwow_pair.dart';

// lib/core/domain/ports/empty_trips/superwow_management.port.dart

abstract class SuperWowManagementPort {
  // Les méthodes existantes restent
  Future<List<ScoredActivity>> getTripSuperWows(String tripId);
  Future<ScoredActivity> findClosestSuperWow(
      List<ScoredActivity> superWows,
      LatLng fromPoint,
      );

  // Nouvelle méthode plus simple qui fait tout le processus
  Future<List<SuperWowPair>> generateOptimizedPairs(
      String tripId,
      List<ScoredActivity> superWows,
      LatLng departurePoint,
      );
}