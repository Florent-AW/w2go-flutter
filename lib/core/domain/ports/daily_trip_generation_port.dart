// core/domain/ports/daily_trip_generation_port.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/trip_designer/trip/daily_trip.dart';
import '../models/scored_activity.dart';

abstract class DailyTripGenerationPort {
  Future<List<DailyTrip>> generateHalfDayTrips({
    required String tripId,
    required List<ScoredActivity> superWows,
    required LatLng departurePoint,
    required LatLng arrivalPoint,
  });

  Future<List<DailyTrip>> generateFullDayTrips({
    required String tripId,
    required List<ScoredActivity> superWows,
    required LatLng departurePoint,
    required LatLng arrivalPoint,
    required Map<String, dynamic> momentPreferences,
  });
}