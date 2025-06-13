// lib/features/activity_detail/providers/activity_detail_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/adapters/supabase/search/activity_details_adapter.dart';
import '../../../../core/domain/ports/search/activity_details_port.dart';
import '../../domain/usecases/get_activity_details_use_case.dart';
import '../state/activity_detail_notifier.dart';
import '../state/activity_detail_state.dart';

/// Provider pour l'adapter de détails d'activité
final activityDetailsAdapterProvider = Provider<ActivityDetailsPort>((ref) {
  final client = Supabase.instance.client;
  return ActivityDetailsAdapter(client);
});

/// Provider pour le use case de récupération des détails d'activité
final getActivityDetailsUseCaseProvider = Provider<GetActivityDetailsUseCase>((ref) {
  final activityDetailsPort = ref.watch(activityDetailsAdapterProvider);
  return GetActivityDetailsUseCase(activityDetailsPort);
});

/// Provider pour l'état des détails d'une activité spécifique
// Provider pour le notifier avec référence Riverpod
final activityDetailProvider = StateNotifierProvider.family<ActivityDetailNotifier, ActivityDetailState, String>(
      (ref, activityId) {
    final useCase = ref.watch(getActivityDetailsUseCaseProvider);
    return ActivityDetailNotifier(useCase, ref); // ✅ Passer ref pour accès aux providers
  },
);