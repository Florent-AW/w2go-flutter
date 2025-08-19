// core/domain/ports/search/activities_by_concept_sections_port.dart

import '../../models/search/result_section.dart';
import '../../models/search/concept_types.dart';

abstract class ActivitiesByConceptSectionsPort {
  Future<List<ResultSection>> fetchSections({
    required String conceptId,
    required ConceptType conceptType,
    required double lat,
    required double lon,
    String scope = 'terms_results',
  });
}
