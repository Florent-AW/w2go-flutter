// lib/core/domain/services/empty_trips/potential_activities.service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../ports/empty_trips/potential_activities.port.dart';
import '../../../models/trip_designer/empty_trips/empty_daily_trip.dart';
import '../../../models/trip_designer/trip/activity_model.dart';
import '../../../../common/exceptions/calculation_exception.dart';

class PotentialActivitiesService implements PotentialActivitiesPort {
  final SupabaseClient _supabase;

  PotentialActivitiesService(this._supabase);

  @override
  Future<Map<String, List<Activity>>> getFilteredActivitiesForEmptyTrip({
    required EmptyDailyTrip emptyTrip,
    required String tripId,
    required Map<DateTime, int> availableTimeByDate,
  }) async {
    try {
      // 1. Filtrer les dates avec du temps disponible
      final validDates = availableTimeByDate.entries
          .where((entry) => entry.value > 0)
          .map((e) => e.key)
          .toList();

      if (validDates.isEmpty) return {};

      // 2. Récupérer les activités depuis trip_activities
      final response = await _supabase
          .from('trip_activities')
          .select('activity_id, planned_date')
          .eq('trip_id', tripId);

      // 3. Convertir en Map date -> List<Activity>
      Map<String, List<Activity>> activitiesByDate = {};

      for (final date in validDates) {
        final activities = await _getActivitiesForDate(
          emptyTrip: emptyTrip,
          tripId: tripId,
          date: date,
          existingActivityIds: (response as List)
              .where((r) => r['planned_date'] == date.toIso8601String())
              .map((r) => r['activity_id'] as String)
              .toList(),
        );

        if (activities.isNotEmpty) {
          activitiesByDate[date.toIso8601String()] = activities;
        }
      }

      return activitiesByDate;
    } catch (e) {
      throw CalculationException('Error getting filtered activities: $e');
    }
  }

  Future<List<Activity>> _getActivitiesForDate({
    required EmptyDailyTrip emptyTrip,
    required String tripId,
    required DateTime date,
    required List<String> existingActivityIds,
  }) async {
    // Exclure les SW
    final excludeIds = [...existingActivityIds, emptyTrip.sw1Id];
    if (emptyTrip.sw2Id != null) excludeIds.add(emptyTrip.sw2Id!);

    // Récupérer les activités dans le geohash5
    final response = await _supabase
        .from('activities')
        .select()
        .eq('geohash_5', emptyTrip.departureGeohash5)
        .not('id', 'in', excludeIds);

    return (response as List)
        .map((json) => Activity.fromJson(json))
        .toList();
  }
}