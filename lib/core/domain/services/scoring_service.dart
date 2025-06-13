// core/domain/services/scoring_service.dart

import 'dart:math' as math;
import '../models/trip_designer/scoring/scoring_config.dart';
import '../models/trip_designer/processing/activity_processing_model.dart';

class ScoringService {
  static const double SUPERWOW_TOTAL_THRESHOLD = 0.78;
  static const double SUPERWOW_SUBCATEGORY_THRESHOLD = 0.6;

  double calculateTotalScore(ActivityForProcessing activity, double subcategoryScore) {
    final ratingScore = normalizeRating(activity.ratingCount);
    final durationScore = calculateDurationBonus(activity.minDurationMinutes);

    return (subcategoryScore * ScoringConfig.subcategoryWeight) +
        (ratingScore * ScoringConfig.ratingWeight) +
        (durationScore * ScoringConfig.durationWeight);
  }

  double normalizeRating(int rating) {
    return rating / 100;
  }

  double calculateDurationBonus(int durationMinutes) {
    return math.log(durationMinutes + 1) / math.log(10);
  }

  bool isSuperWow(double totalScore, double subcategoryScore) {
    return totalScore >= SUPERWOW_TOTAL_THRESHOLD &&
        subcategoryScore >= SUPERWOW_SUBCATEGORY_THRESHOLD;
  }
}