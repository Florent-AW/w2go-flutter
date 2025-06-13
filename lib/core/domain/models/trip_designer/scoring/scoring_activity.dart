// core/domain/models/scoring/scored_activity.dart

import '../processing/activity_processing_model.dart';

class ScoredActivity {
  final ActivityForProcessing activity;
  final double totalScore;
  final double subcategoryScore;
  final bool isSuperWow;
  final DateTime? superwowValidityPeriod;
  final Map<String, dynamic>? superwowScoreSnapshot;

  const ScoredActivity({
    required this.activity,
    required this.totalScore,
    required this.subcategoryScore,
    this.isSuperWow = false,
    this.superwowValidityPeriod,
    this.superwowScoreSnapshot,
  });

  factory ScoredActivity.fromJson(Map<String, dynamic> json, ActivityForProcessing activity) {
    return ScoredActivity(
      activity: activity,
      totalScore: json['total_score']?.toDouble() ?? 0.0,
      subcategoryScore: json['subcategory_score']?.toDouble() ?? 0.0,
      isSuperWow: json['is_superwow'] ?? false,
      superwowValidityPeriod: json['superwow_validity_period'] != null
          ? DateTime.parse(json['superwow_validity_period'])
          : null,
      superwowScoreSnapshot: json['superwow_score_snapshot'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_id': activity.id,
      'total_score': totalScore,
      'subcategory_score': subcategoryScore,
      'is_superwow': isSuperWow,
      'superwow_validity_period': superwowValidityPeriod?.toIso8601String(),
      'superwow_score_snapshot': superwowScoreSnapshot,
    };
  }
}