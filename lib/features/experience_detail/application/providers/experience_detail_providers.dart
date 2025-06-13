// lib/features/experience_detail/application/providers/experience_detail_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/adapters/supabase/search/event_details_adapter.dart';
import '../../../../core/domain/ports/search/event_details_port.dart';
import '../../../event_detail/domain/usecases/get_event_details_use_case.dart';
import '../../../activity_detail/application/providers/activity_detail_providers.dart';
import '../../domain/usecases/get_experience_details_use_case.dart';
import '../state/experience_detail_notifier.dart';
import '../state/experience_detail_state.dart';

/// Provider pour l'adapter Event Details (Supabase)
final eventDetailsAdapterProvider = Provider<EventDetailsPort>((ref) {
  final client = Supabase.instance.client;
  return EventDetailsAdapter(client);
});

/// Provider pour le use case Event Details
final getEventDetailsUseCaseProvider = Provider<GetEventDetailsUseCase>((ref) {
  final eventDetailsPort = ref.read(eventDetailsAdapterProvider);
  return GetEventDetailsUseCase(eventDetailsPort);
});

/// Provider pour le use case Experience Details unifié
final getExperienceDetailsUseCaseProvider = Provider<GetExperienceDetailsUseCase>((ref) {
  final activityUseCase = ref.read(getActivityDetailsUseCaseProvider);
  final eventUseCase = ref.read(getEventDetailsUseCaseProvider);
  return GetExperienceDetailsUseCase(activityUseCase, eventUseCase);
});

/// Provider pour le notifier Experience Detail avec clé par ExperienceItem
final experienceDetailProvider = StateNotifierProvider.family<ExperienceDetailNotifier, ExperienceDetailState, ExperienceItem>(
      (ref, experienceItem) {
    final useCase = ref.read(getExperienceDetailsUseCaseProvider);
    return ExperienceDetailNotifier(useCase, ref);
  },
);