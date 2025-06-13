// lib/core/domain/ports/providers/empty_trips/empty_daily_trip.provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../empty_trips/empty_daily_trip.port.dart';
import '../../../../adapters/supabase/empty_daily_trip.adapter.dart';
import '../infrastructure_providers.dart';

final emptyDailyTripPortProvider = Provider<EmptyDailyTripPort>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return EmptyDailyTripAdapter(supabase);
});