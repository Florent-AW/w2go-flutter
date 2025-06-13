// core/domain/models/scoring/scoring_config.dart

import 'dart:math' as math;

class ScoringConfig {
  // Pondérations
  static const double subcategoryWeight = 0.5;
  static const double ratingWeight = 0.4;
  static const double durationWeight = 0.1;

  // Scores sous-catégories
  static const Map<String, double> subcategoryScores = {
    'adore': 1.0,
    'aime': 0.6,
    'parfois': 0.3
  };
}