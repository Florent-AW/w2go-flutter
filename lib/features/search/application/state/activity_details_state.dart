// lib/features/search/application/state/activity_details_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/shared/activity_details_model.dart';
import '../../../../core/domain/ports/search/activity_details_port.dart';
import '../../../../core/adapters/supabase/database_adapter.dart';
import '../../../../core/adapters/supabase/search/activity_details_adapter.dart';

part 'activity_details_state.freezed.dart';

@freezed
class ActivityDetailsState with _$ActivityDetailsState {
  const factory ActivityDetailsState.initial() = _Initial;
  const factory ActivityDetailsState.loading() = _Loading;
  const factory ActivityDetailsState.loaded(ActivityDetails details) = _Loaded;
  const factory ActivityDetailsState.error(String message) = _Error;
}

class ActivityDetailsNotifier extends StateNotifier<ActivityDetailsState> {
  final ActivityDetailsPort _port;

  ActivityDetailsNotifier(this._port) : super(const ActivityDetailsState.initial());

  Future<void> loadActivityDetails(String activityId) async {
    print('StateNotifier: Loading details for activity: $activityId');
    state = const ActivityDetailsState.loading();
    try {
      print('StateNotifier: Calling port.getActivityDetails');
      final details = await _port.getActivityDetails(activityId);
      print('StateNotifier: Got details successfully');
      state = ActivityDetailsState.loaded(details);
    } catch (e) {
      print('StateNotifier: Error loading details: $e');
      state = ActivityDetailsState.error(e.toString());
    }
  }
}

// Un seul provider qui combine tout
final activityDetailsProvider = StateNotifierProvider.autoDispose<ActivityDetailsNotifier, ActivityDetailsState>((ref) {
  return ActivityDetailsNotifier(
      ActivityDetailsAdapter(SupabaseService.client)
  );
});