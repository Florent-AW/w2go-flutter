// lib/core/adapters/supabase/potential_bonus_activity.adapter.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/trip_designer/bonus_activities/potential_bonus_activity.dart';
import '../../common/exceptions/geometry_calculation_exception.dart';

class PotentialBonusActivityAdapter {
  final SupabaseClient _supabase;
  static const String _tableName = 'trip_potential_bonus_activities';

  PotentialBonusActivityAdapter(this._supabase);

  Future<void> savePotentialBonusActivities(
      List<PotentialBonusActivity> activities
      ) async {
    try {
      final batch = activities.map((activity) => activity.toJson()).toList();

      await _supabase
          .from(_tableName)
          .upsert(
          batch,
          onConflict: 'trip_potential_bonus_unique'
      );
    } catch (e) {
      throw GeometryCalculationException(
          'Failed to save potential bonus activities: $e'
      );
    }
  }

  Future<List<PotentialBonusActivity>> getPotentialBonusActivities({
    required String emptyTripId,
  }) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('empty_daily_trip_id', emptyTripId);

      return (response as List)
          .map((json) => PotentialBonusActivity.fromJson(json))
          .toList();
    } catch (e) {
      throw GeometryCalculationException(
          'Failed to get potential bonus activities: $e'
      );
    }
  }

  Future<void> deletePotentialBonusActivities({
    required String emptyTripId,
  }) async {
    try {
      await _supabase
          .from(_tableName)
          .delete()
          .eq('empty_daily_trip_id', emptyTripId);
    } catch (e) {
      throw GeometryCalculationException(
          'Failed to delete potential bonus activities: $e'
      );
    }
  }

  Future<void> updatePotentialBonusActivity(
      PotentialBonusActivity activity
      ) async {
    try {
      await _supabase
          .from(_tableName)
          .update(activity.toJson())
          .eq('id', activity.id);
    } catch (e) {
      throw GeometryCalculationException(
          'Failed to update potential bonus activity: $e'
      );
    }
  }
}