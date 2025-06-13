// lib/features/empty_trips/presentation/state/providers/bonus_activities.providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../adapters/supabase/potential_bonus_activity.adapter.dart';
import '../../../../adapters/postgis/geometry_calculation.adapter.dart';
import '../../../services/designer/empty_trips/distance_calculation.service.dart';
import '../../../services/designer/empty_trips/bonus_activity_generation.service.dart';
import '../../../services/designer/empty_trips/available_time_calculation.service.dart';
import '../../../services/designer/empty_trips/notifier/potential_bonus_activities.notifier.dart';
import '../../../models/trip_designer/bonus_activities/potential_bonus_activity.dart';


// Adapters providers
final potentialBonusActivityAdapterProvider = Provider<PotentialBonusActivityAdapter>((ref) {
  final supabase = Supabase.instance.client;
  return PotentialBonusActivityAdapter(supabase);
});

final geometryCalculationAdapterProvider = Provider<GeometryCalculationAdapter>((ref) {
  final supabase = Supabase.instance.client;
  return GeometryCalculationAdapter(supabase);
});

// Services providers
final distanceCalculationServiceProvider = Provider<DistanceCalculationService>((ref) {
  final geometryPort = ref.watch(geometryCalculationAdapterProvider);
  return DistanceCalculationService(geometryPort);
});

final bonusActivityGenerationServiceProvider = Provider<BonusActivityGenerationService>((ref) {
  final geometryPort = ref.watch(geometryCalculationAdapterProvider);
  final distanceService = ref.watch(distanceCalculationServiceProvider);
  final availableTimeService = ref.watch(availableTimeServiceProvider); // Ajouter ce provider

  return BonusActivityGenerationService(
      geometryPort,
      distanceService,
      availableTimeService // Ajouter le 3ème argument
  );
});

final availableTimeServiceProvider = Provider<AvailableTimeCalculationService>((ref) {
  final supabase = Supabase.instance.client;
  return AvailableTimeCalculationService(supabase);
});

// State providers si nécessaire pour la gestion d'état
final potentialBonusActivitiesProvider = StateNotifierProvider<PotentialBonusActivitiesNotifier, AsyncValue<List<PotentialBonusActivity>>>((ref) {
  final adapter = ref.watch(potentialBonusActivityAdapterProvider);
  final geometryPort = ref.watch(geometryCalculationAdapterProvider);
  final distanceService = ref.watch(distanceCalculationServiceProvider);
  final availableTimeService = ref.watch(availableTimeServiceProvider);

  final bonusService = BonusActivityGenerationService(
      geometryPort,
      distanceService,
      availableTimeService
  );

  return PotentialBonusActivitiesNotifier(adapter, bonusService);
});