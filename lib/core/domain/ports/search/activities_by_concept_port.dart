// core/domain/ports/search/activities_by_concept_port.dart

import '../../models/activity/search/searchable_activity.dart';
import '../../models/search/concept_types.dart';
import '../../pagination/paginated_result.dart';

abstract class ActivitiesByConceptPort {
  Future<PaginatedResult<SearchableActivity>> list({
    required String conceptId,
    required ConceptType conceptType,
    required double lat,
    required double lon,
    double radiusKm = 50,
    SortMode sort = SortMode.distance,
    int limit = 20,
    int offset = 0,
  });
}
