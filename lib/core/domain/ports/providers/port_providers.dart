// core/domain/ports/providers/port_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../adapters/trip/trip_adapter.dart';
import '../../../adapters/supabase/activity_processing_adapter.dart';
import '../trip_port.dart';
import '../activity_processing_port.dart';
import '../../../adapters/supabase/activity_hours_adapter.dart';
import '../activity_hours_port.dart';
import 'infrastructure_providers.dart';

final tripPortProvider = Provider<TripPort>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return TripAdapter(supabase);
});

final activityProcessingPortProvider = Provider<ActivityProcessingPort>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return ActivityProcessingAdapter(supabase);
});

final activityHoursPortProvider = Provider<ActivityHoursPort>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return ActivityHoursAdapter(supabase);
});