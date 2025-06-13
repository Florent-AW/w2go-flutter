// lib/core/domain/ports/providers/trip_activities_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ports/trip_activities_port.dart';
import '../../../adapters/supabase/trip_activities_adapter.dart';
import 'infrastructure_providers.dart';

final tripActivitiesPortProvider = Provider<TripActivitiesPort>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return TripActivitiesAdapter(supabase);
});