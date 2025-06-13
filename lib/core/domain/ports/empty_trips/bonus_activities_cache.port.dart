// lib/core/domain/ports/empty_trips/bonus_activities_cache.port.dart

abstract class BonusActivitiesCachePort {
  Future<void> cacheEmptyTripBonusActivities({
    required String emptyTripId,
    required List<Map<String, dynamic>> bonusActivities,
  });

  Future<List<Map<String, dynamic>>> getCachedBonusActivities(String emptyTripId);
}