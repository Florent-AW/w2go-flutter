// lib/core/domain/use_cases/search/get_activities_use_case.dart

import '../../models/activity/search/searchable_activity.dart';
import '../../models/search/activity_filter.dart';
import '../../ports/search/activity_search_port.dart';

final class GetActivitiesUseCase {
  final ActivitySearchPort _searchPort;
  GetActivitiesUseCase(this._searchPort);

  /// Ajout du paramètre subcategoryId
  Future<List<SearchableActivity>> execute({
    required double latitude,
    required double longitude,
    required String sectionId,
    String? subcategoryId,
    String? categoryId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Crée un filtre incluant sectionId et subcategoryId
      final filter = ActivityFilter(
        categoryId: categoryId,
        subcategoryId: subcategoryId,
        sectionId: sectionId,  // IMPORTANT: inclure le sectionId ici
        limit: limit,
        offset: offset,
      );

      return _searchPort.getActivitiesWithFilter(
        filter,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      print('❌ Error in execute: $e');
      return [];
    }
  }
}
