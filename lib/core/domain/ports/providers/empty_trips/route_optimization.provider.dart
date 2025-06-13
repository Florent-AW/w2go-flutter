// core/domain/ports/providers/empty_trips/route_optimization.provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../empty_trips/route_optimization.port.dart';
import '../../../../adapters/google/route_optimization.adapter.dart';
import '../infrastructure_providers.dart';
import './google_services_config.provider.dart';
import './google_ai_studio.provider.dart';

final routeOptimizationPortProvider = Provider<RouteOptimizationPort>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final config = ref.watch(googleServicesConfigProvider);
  final googleService = ref.watch(googleAIStudioServiceProvider);

  return RouteOptimizationAdapter(supabase, config, googleService);
});