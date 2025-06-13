// lib/core/domain/models/search/recommendation/recommendation_result.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../activity/search/searchable_activity.dart';

part 'recommendation_result.freezed.dart';
part 'recommendation_result.g.dart';

@freezed
class RecommendationResult with _$RecommendationResult {
  const factory RecommendationResult({
    required List<SearchableActivity> activities,  // Pool d'activités
    required int totalFound,                       // Nombre total trouvé
    required String sectionType,                   // Type de section
    String? sectionTitle,                          // Titre depuis Supabase
    int? configLimit,                              // Limite depuis config
    String? cacheKey,                              // Clé cache (debug)
    DateTime? generatedAt,                         // Timestamp génération
  }) = _RecommendationResult;

  factory RecommendationResult.fromJson(Map<String, dynamic> json) =>
      _$RecommendationResultFromJson(json);
}