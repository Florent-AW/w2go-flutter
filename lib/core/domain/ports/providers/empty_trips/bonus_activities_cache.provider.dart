// lib/core/domain/ports/providers/empty_trips/bonus_activities_cache.provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/designer/empty_trips/bonus_activities_cache.service.dart';


final bonusActivitiesCacheProvider = Provider<BonusActivitiesCacheService>((ref) {
  final supabase = Supabase.instance.client;
  return BonusActivitiesCacheService(supabase);
});