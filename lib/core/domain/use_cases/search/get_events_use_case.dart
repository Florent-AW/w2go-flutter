// lib/core/domain/use_cases/search/get_events_use_case.dart

import '../../models/event/search/searchable_event.dart';
import '../../models/search/activity_filter.dart';
import '../../ports/search/event_search_port.dart';

final class GetEventsUseCase {
  final EventSearchPort _searchPort;
  GetEventsUseCase(this._searchPort);

  /// Ajout du paramètre subcategoryId
  Future<List<SearchableEvent>> execute({
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

      return _searchPort.getEventsWithFilter(
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