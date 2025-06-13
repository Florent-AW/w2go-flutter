// lib/core/domain/models/scored_activity.dart

class ScoredActivity {
  final String id;
  final double totalScore;
  final double subcategoryScore;
  final bool isSuperwow;
  final Map<String, dynamic> activityData;  // Données brutes de l'activité

  const ScoredActivity({
    required this.id,
    required this.totalScore,
    required this.subcategoryScore,
    required this.isSuperwow,
    required this.activityData,
  });

  /// Crée une instance depuis les données JSON de Supabase
  factory ScoredActivity.fromJson(Map<String, dynamic> json) {
    return ScoredActivity(
      id: json['id'],
      totalScore: json['total_score']?.toDouble() ?? 0.0,
      subcategoryScore: json['subcategory_score']?.toDouble() ?? 0.0,
      isSuperwow: json['is_superwow'] ?? false,
      activityData: json,
    );
  }

  /// Convertit l'instance en Map pour Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_score': totalScore,
      'subcategory_score': subcategoryScore,
      'is_superwow': isSuperwow,
      ...activityData,  // Inclut toutes les données de l'activité
    };
  }
}