// // lib/core/domain/ports/providers/route_optimization_providers.dart
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../ports/daily_trip_generation_port.dart';
// import '../../../adapters/supabase/daily_trip_generation_adapter.dart';
// import 'infrastructure_providers.dart';
// import 'empty_trips/route_optimization_providers.dart';
// import 'empty_trips/empty_daily_trip_provider.dart';
//
// final dailyTripGenerationPortProvider = Provider<DailyTripGenerationPort>((ref) {
//   final supabase = ref.watch(supabaseProvider);
//   final routeOptimization = ref.watch(routeOptimizationPortProvider);
//   final emptyTripPort = ref.watch(emptyDailyTripPortProvider);
//
//   return DailyTripGenerationAdapter(
//     supabase,
//     routeOptimization,
//     emptyTripPort,
//   );
// });