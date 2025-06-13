// lib/core/domain/services/empty_trips/bonus_activities_cache.service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../ports/empty_trips/bonus_activities_cache.port.dart';
import '../../../../common/exceptions/calculation_exception.dart';

class BonusActivitiesCacheService implements BonusActivitiesCachePort {
  final SupabaseClient _supabase;
  static const String _tableName = 'empty_trip_bonus_activities';

  BonusActivitiesCacheService(this._supabase);

  @override
  Future<void> cacheEmptyTripBonusActivities({
    required String emptyTripId,
    required List<Map<String, dynamic>> bonusActivities,
  }) async {
    try {
      for (var activity in bonusActivities) {
        // Vérifier si la combinaison existe déjà
        final existing = await _supabase
            .from(_tableName)
            .select()
            .eq('empty_daily_trip_id', emptyTripId)
            .eq('activity_id', activity['id'])
            .maybeSingle();

        if (existing == null) {
          // Si elle n'existe pas, l'insérer
          await _supabase
              .from(_tableName)
              .insert({
            'empty_daily_trip_id': emptyTripId,
            'activity_id': activity['id'],
            'malus_vol_oiseau': activity['malus'],
          });
        }
      }
    } catch (e) {
      throw CalculationException('Failed to cache bonus activities: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedBonusActivities(String emptyTripId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('empty_daily_trip_id', emptyTripId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw CalculationException('Failed to get cached bonus activities: $e');
    }
  }
}