// lib/core/domain/ports/providers/empty_trips/potential_activities.provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/designer/empty_trips/potential_activities.service.dart';

final potentialActivitiesProvider = Provider<PotentialActivitiesService>((ref) {
  final supabase = Supabase.instance.client;
  return PotentialActivitiesService(supabase);
});