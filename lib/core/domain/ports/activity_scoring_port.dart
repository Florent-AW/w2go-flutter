// core/domain/ports/activity_scoring_port.dart

import '../models/trip_designer/scoring/scoring_activity.dart';
import '../models/trip_designer/processing/activity_processing_model.dart';

abstract class ActivityScoringPort {
  Future<List<ScoredActivity>> scoreActivities(String userId, List<ActivityForProcessing> activities);
  Future<Map<String, double>> getUserPreferences(String userId);
}