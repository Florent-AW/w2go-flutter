// core/domain/ports/providers/empty_trips/distance_calculation.provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/designer/empty_trips/distance_calculation.service.dart';

final distanceCalculationServiceProvider = Provider<DistanceCalculationService>((ref) {
  return DistanceCalculationService();
});