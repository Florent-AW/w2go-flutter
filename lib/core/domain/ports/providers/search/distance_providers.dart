// lib/core/domain/ports/providers/search/distance_providers.dart

import 'package:riverpod/riverpod.dart';
import '../../../ports/search/activity_distance_calculation_port.dart';
import '../../../services/search/activity_distance_service.dart';

final activityDistanceProvider = Provider<ActivityDistanceCalculationPort>((ref) {
  return ActivityDistanceService();
});