// lib/core/domain/ports/providers/empty_trips/empty_trip_generation.provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/designer/empty_trips/empty_trip_generation.service.dart';
import 'superwow_management.provider.dart';
import 'route_optimization.provider.dart';
import '../infrastructure_providers.dart';
import 'empty_daily_trip.provider.dart';
import 'neighbor_geohashes.provider.dart';

final emptyTripGenerationServiceProvider = Provider<EmptyTripGenerationService>((ref) {
  final superwowPort = ref.watch(superwowManagementPortProvider);
  final routePort = ref.watch(routeOptimizationPortProvider);
  final emptyTripPort = ref.watch(emptyDailyTripPortProvider);
  final supabase = ref.watch(supabaseProvider);
  final neighborGeohashesService = ref.watch(neighborGeohashesProvider);

  return EmptyTripGenerationService(
    superwowPort,
    routePort,
    emptyTripPort,
    neighborGeohashesService,
    supabase,
  );
});