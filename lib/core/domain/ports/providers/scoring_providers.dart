// core/domain/providers/scoring_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'infrastructure_providers.dart';
import '../activity_scoring_port.dart';
import '../../../adapters/supabase/activity_scoring_adapter.dart';
import '../../services/scoring_service.dart';

final scoringServiceProvider = Provider<ScoringService>((ref) {
  return ScoringService();
});

final activityScoringPortProvider = Provider<ActivityScoringPort>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return ActivityScoringAdapter(supabase);
});