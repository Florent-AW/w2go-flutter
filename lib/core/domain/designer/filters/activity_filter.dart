// lib\core\domain\designer\filters\activity_filter.dart

import '../../models/trip_designer/processing/activity_processing_model.dart';

abstract class ActivityFilter {
  Future<List<ActivityForProcessing>> apply(List<ActivityForProcessing> activities);
  String? get exclusionReason;
}