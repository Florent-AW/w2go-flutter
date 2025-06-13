// core/domain/ports/providers/empty_trips/superwow_management.provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_optimization.provider.dart';
import 'distance_calculation_provider.dart';
import '../infrastructure_providers.dart';
import '../../empty_trips/superwow_management.port.dart';
import '../../../../adapters/supabase/superwow_management.adapter.dart';
import '../../../services/designer/empty_trips/distance_calculation.service.dart';

final superwowManagementPortProvider = Provider<SuperWowManagementPort>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final routeOptimization = ref.watch(routeOptimizationPortProvider);
  final distanceService = ref.watch(distanceCalculationServiceProvider);

  return SuperWowManagementAdapter(
    supabase,
    routeOptimization,
    distanceService,
  );
});