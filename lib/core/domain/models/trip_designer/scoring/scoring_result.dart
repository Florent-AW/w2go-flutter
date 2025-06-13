// core/domain/models/scoring/scoring_result.dart


class ScoringResult {
  final double totalScore;
  final double subcategoryScore;
  final bool isSuperWow;
  final DateTime? superwowValidityPeriod;
  final Map<String, dynamic>? superwowScoreSnapshot;

  const ScoringResult({
    required this.totalScore,
    required this.subcategoryScore,
    required this.isSuperWow,
    this.superwowValidityPeriod,
    this.superwowScoreSnapshot,
  });

  // Optionnel : Factory pour créer depuis JSON
  factory ScoringResult.fromJson(Map<String, dynamic> json) {
    return ScoringResult(
      totalScore: json['total_score']?.toDouble() ?? 0.0,
      subcategoryScore: json['subcategory_score']?.toDouble() ?? 0.0,
      isSuperWow: json['is_superwow'] ?? false,
      superwowValidityPeriod: json['superwow_validity_period'] != null
          ? DateTime.parse(json['superwow_validity_period'])
          : null,
      superwowScoreSnapshot: json['superwow_score_snapshot'],
    );
  }

  // Optionnel : Conversion en JSON
  Map<String, dynamic> toJson() {
    return {
      'total_score': totalScore,
      'subcategory_score': subcategoryScore,
      'is_superwow': isSuperWow,
      'superwow_validity_period': superwowValidityPeriod?.toIso8601String(),
      'superwow_score_snapshot': superwowScoreSnapshot,
    };
  }
}