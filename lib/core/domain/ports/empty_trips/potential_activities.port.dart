// lib/core/domain/ports/empty_trips/potential_activities.port.dart

import '../../models/trip_designer/empty_trips/empty_daily_trip.dart';
import '../../models/trip_designer/trip/activity_model.dart';

abstract class PotentialActivitiesPort {
  Future<Map<String, List<Activity>>> getFilteredActivitiesForEmptyTrip({
    required EmptyDailyTrip emptyTrip,
    required String tripId,
    required Map<DateTime, int> availableTimeByDate,
  });
}