// lib/core/domain/ports/empty_trips/empty_daily_trip_port.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/trip_designer/empty_trips/empty_daily_trip.dart';
import '../../../common/enums/trip_enums.dart';



abstract class EmptyDailyTripPort {
  /// Vérifie si un empty trip existe déjà avec ces paramètres
  Future<EmptyDailyTrip?> findExistingEmptyTrip({
    required DailyTripType type,
    required String departureGeohash5,
    required String arrivalGeohash5,
    required String sw1Id,
    String? sw2Id,
  });

  /// Crée un nouvel empty trip
  Future<EmptyDailyTrip> createEmptyTrip({
    required DailyTripType type,
    required String departureGeohash5,
    required String arrivalGeohash5,
    required String sw1Id,
    String? sw2Id,
    required List<String> traversedGeohashes,
    required String routePolyline,
    required int totalDuration,     // Ajout
    required int totalDistance,
  });

  Future<EmptyDailyTrip> getEmptyTrip(String emptyTripId);

}