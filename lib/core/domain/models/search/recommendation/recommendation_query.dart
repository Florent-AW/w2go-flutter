// lib/core/domain/models/search/recommendation/recommendation_query.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_query.freezed.dart';
part 'recommendation_query.g.dart';

@freezed
class RecommendationQuery with _$RecommendationQuery {
  const factory RecommendationQuery({
    required String sectionType,        // ✅ Seul required
    int? limit,                         // ✅ Optionnel (config Supabase)
    bool? excludeCurrentActivity,
    String? orderBy,                    // 'rating_avg', 'rating_count'
    String? orderDirection,             // 'DESC', 'ASC'
    double? maxDistanceKm,              // pour nearby
    bool? sameSubcategory,              // pour similar
    double? minRating,                  // filtre qualité
    String? rotation,                   // 'none' | 'daily'
    bool? randomSample,                 // sampling client
  }) = _RecommendationQuery;

  factory RecommendationQuery.fromJson(Map<String, dynamic> json) =>
      _$RecommendationQueryFromJson(json);
}