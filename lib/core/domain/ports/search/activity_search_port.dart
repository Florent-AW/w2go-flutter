// lib/core/domain/ports/search/activity_search_port.dart

import '../../models/activity/search/searchable_activity.dart';
import '../../models/search/activity_filter.dart';

abstract class ActivitySearchPort {
  /// Récupère des activités en utilisant un filtre structuré
  /// Cette méthode utilise la nouvelle architecture avec section_id
  Future<List<SearchableActivity>> getActivitiesWithFilter(
      ActivityFilter filter, {
        required double latitude,
        required double longitude,
        String? cityId,
      });

  /// Méthode de compatibilité avec l'ancienne approche
  /// À terme, cette méthode pourrait être supprimée lorsque tous les appels auront été migrés
  Future<List<SearchableActivity>> getActivitiesWithFilters({
    required double latitude,
    required double longitude,
    String? cityId,
    String? categoryId,
    String? subcategoryId,
    bool? isWow,
    double? maxDistance,
    double? minRating,
    int? minRatingCount,
    int? maxRatingCount,
    bool? kidFriendly,
    String? orderBy,
    String? orderDirection,
    int? limit,
    Map<String, dynamic>? rawFilters,
  });
}