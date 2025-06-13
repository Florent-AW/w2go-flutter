// lib/core/domain/ports/empty_trips/available_time_calculation.port.dart

import '../../models/trip_designer/empty_trips/empty_daily_trip.dart';

abstract class AvailableTimeCalculationPort {
  Future<int> calculateAvailableTime({
    required String emptyTripId,
    required Map<String, dynamic> activityHours,
    required String travelStyle,
    required List<String> superWowIds,
  });

  Future<int> calculateSuperWowDuration({
    required List<String> superWowIds,
    required String travelStyle,
  });

  int calculateMealBreaksDuration(Map<String, dynamic> activityHours, String travelStyle);

  Future<Map<DateTime, int>> calculateAvailableTimeForEmptyTrip({
    required EmptyDailyTrip emptyTrip,
    required Map<String, Map<String, String?>> dailyHours,
    required String travelStyle,
  });
}