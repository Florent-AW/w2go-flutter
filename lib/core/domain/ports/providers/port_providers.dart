// core/domain/ports/providers/port_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../adapters/trip/trip_adapter.dart';
import '../../../adapters/supabase/activity_processing_adapter.dart';
import '../trip_port.dart';
import '../activity_processing_port.dart';
import '../../../adapters/supabase/activity_hours_adapter.dart';
import '../activity_hours_port.dart';

final supabaseProvider = Provider((ref) => Supabase.instance.client);

final tripPortProvider = Provider<TripPort>((ref) {
  final supabase = Supabase.instance.client;  // Utilisation directe de Supabase.instance
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