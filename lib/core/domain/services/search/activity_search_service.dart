// lib/core/domain/services/search/activity_search_service.dart

import '../../models/activity/search/searchable_activity.dart';
import '../../models/search/activity_filter.dart';
import '../../ports/search/activity_search_port.dart';

/// Service pour la recherche d'activités
/// Encapsule la logique métier de recherche d'activités
class ActivitySearchService {
  final ActivitySearchPort _searchPort;

  ActivitySearchService(this._searchPort);

  /// Recherche des activités avec un filtre personnalisé
  /// Point d'entrée principal pour la recherche d'activités basée sur une configuration
  Future<List<SearchableActivity>> searchWithFilter({
    required double latitude,
    required double longitude,
    required ActivityFilter filter,
    String? cityId,
  }) async {
    try {
      return await _searchPort.getActivitiesWithFilter(
        filter,
        latitude: latitude,
        longitude: longitude,
        cityId: cityId,
      );
    } catch (e) {
      print('❌ Erreur lors de la recherche avec filtre personnalisé: $e');
      return [];
    }
  }

  /// Recherche des activités par sous-catégorie avec un ordre spécifique
  Future<List<SearchableActivity>> getActivitiesBySubcategory({
    required double latitude,
    required double longitude,
    required String categoryId,
    required String subcategoryId,
    String? cityId,
    String orderBy = 'rating_avg',
    String orderDirection = 'DESC',
    int limit = 10,
  }) async {
    try {
      // Utiliser le constructeur dédié pour le filtrage par sous-catégorie
      final filter = ActivityFilter.forSubcategory(
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        orderBy: orderBy,
        orderDirection: orderDirection,
        limit: limit,
      );

      print('📊 Recherche par sous-catégorie: $subcategoryId (ordre: $orderBy)');

      return await searchWithFilter(
        latitude: latitude,
        longitude: longitude,
        filter: filter,
        cityId: cityId,
      );
    } catch (e) {
      print('❌ Erreur lors de la recherche par sous-catégorie: $e');
      return [];
    }
  }
}