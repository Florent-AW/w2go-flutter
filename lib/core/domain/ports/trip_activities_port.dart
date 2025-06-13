// core/domain/ports/trip_activities_port.dart

import '../models/scored_activity.dart';

abstract class TripActivitiesPort {
  Future<void> saveFilteredActivities({
    required String tripId,
    required List<ScoredActivity> activities,
    required bool isSuperwow,
  });

  Future<List<ScoredActivity>> getSuperwowActivities(String tripId);
}