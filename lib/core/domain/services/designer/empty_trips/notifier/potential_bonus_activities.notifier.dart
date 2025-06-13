// lib/features/empty_trips/presentation/state/potential_bonus_activities.notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/trip_designer/bonus_activities/potential_bonus_activity.dart';
import '../../../../models/trip_designer/empty_trips/empty_daily_trip.dart';
import '../../../../models/trip_designer/trip/activity_model.dart';
import '../../../../models/trip_designer/trip/trip_model.dart';
import '../bonus_activity_generation.service.dart';
import '../../../../../../core/adapters/supabase/potential_bonus_activity.adapter.dart';


class PotentialBonusActivitiesNotifier extends StateNotifier<AsyncValue<List<PotentialBonusActivity>>> {
  final PotentialBonusActivityAdapter _adapter;
  final BonusActivityGenerationService _generationService;

  PotentialBonusActivitiesNotifier(this._adapter, this._generationService)
      : super(const AsyncValue.loading());

  Future<void> generateAndSavePotentialBonusActivities({
    required String emptyTripId,
    required List<Activity> availableActivities,
    required EmptyDailyTrip emptyTrip,
    required Trip trip,
  }) async {
    try {
      state = const AsyncValue.loading();

      final potentialActivities = await _generationService.generatePotentialBonusActivities(
        emptyTripId: emptyTripId,
        availableActivities: availableActivities,
        emptyTrip: emptyTrip,
        trip: trip,
      );

      await _adapter.savePotentialBonusActivities(potentialActivities);

      state = AsyncValue.data(potentialActivities);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadPotentialBonusActivities(String emptyTripId) async {
    try {
      state = const AsyncValue.loading();

      final activities = await _adapter.getPotentialBonusActivities(
        emptyTripId: emptyTripId,
      );

      state = AsyncValue.data(activities);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}