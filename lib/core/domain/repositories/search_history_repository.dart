// core/domain/repositories/search_history_repository.dart

abstract class SearchHistoryRepository {
  Future<void> addTermsExecution({
    required String conceptId,
    required String conceptType,
    required String termTitle,
    String? cityId,
    String? cityName,
    double? lat,
    double? lon,
  });

  Future<void> addSectionsExecution({
    required String sectionId,
    String? filtersJson,
    String? cityId,
    String? cityName,
    double? lat,
    double? lon,
  });

  Stream<List<Map<String, dynamic>>> watchRecent({String? kind, int limit = 50});
  Future<void> clearAll();
  Future<void> setEnabled(bool enabled);
  Stream<bool> watchEnabled();
}