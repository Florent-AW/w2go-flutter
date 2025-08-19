// core/adapters/supabase/search/activities_by_concept_sections_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/models/activity/base/activity_base.dart';
import '../../../domain/models/activity/search/searchable_activity.dart';
import '../../../domain/models/search/concept_types.dart';
import '../../../domain/models/search/result_section.dart';
import '../../../domain/ports/search/activities_by_concept_sections_port.dart';

class ActivitiesByConceptSectionsAdapter implements ActivitiesByConceptSectionsPort {
  final SupabaseClient _client;
  ActivitiesByConceptSectionsAdapter(this._client);

  @override
  Future<List<ResultSection>> fetchSections({
    required String conceptId,
    required ConceptType conceptType,
    required double lat,
    required double lon,
    String scope = 'terms_results',
  }) async {
    final response = await _client.rpc('fn_list_activities_by_concept_sections', params: {
      'p_concept_id': conceptId,
      'p_concept_type': conceptType.asParam,
      'p_lat': lat,
      'p_lon': lon,
      'p_scope': scope,
    });

    final List rows = (response ?? []) as List;
    if (rows.isEmpty) return const [];

    // Group by section tuple (key, title, index)
    final Map<String, (String title, int index, List<SearchableActivity> items)> groups = {};

    for (final r in rows) {
      final row = (r as Map).cast<String, dynamic>();
      final sectionKey = (row['section_key'] ?? '').toString();
      final sectionTitle = (row['section_title'] ?? '').toString();
      final sectionIndex = (row['section_index'] as num?)?.toInt() ?? 0;

      if (sectionKey.isEmpty) {
        // Skip invalid section
        continue;
      }

      final sub = row['subcategory'] is Map
          ? (row['subcategory'] as Map).cast<String, dynamic>()
          : null;
      final imageUrl = row['image_url'] as String?; // preserve null
      final distance = (row['distance_km'] as num?)?.toDouble();

      final base = ActivityBase(
        id: row['id'].toString(),
        name: (row['name'] ?? '').toString(),
        description: null,
        latitude: (row['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (row['longitude'] as num?)?.toDouble() ?? 0.0,
        categoryId: (row['category_id'] ?? '').toString(),
        subcategoryId: row['subcategory_id']?.toString(),
        city: (row['city'] ?? '').toString(),
        imageUrl: imageUrl,
        ratingAvg: (row['rating_avg'] as num?)?.toDouble() ?? 0.0,
        ratingCount: (row['rating_count'] as num?)?.toInt() ?? 0,
      );

      final activity = SearchableActivity(
        base: base,
        categoryName: null,
        subcategoryName: sub?['name']?.toString(),
        subcategoryIcon: sub?['icon']?.toString(),
        distance: distance,
        city: base.city,
        mainImageUrl: imageUrl,
      );

      final existing = groups[sectionKey];
      if (existing == null) {
        groups[sectionKey] = (sectionTitle, sectionIndex, [activity]);
      } else {
        existing.$3.add(activity);
      }
    }

    // Build sections ordered by index asc
    final sections = groups.entries
        .map((e) => ResultSection(key: e.key, title: e.value.$1, index: e.value.$2, items: e.value.$3))
        .toList();

    sections.sort((a, b) => a.index.compareTo(b.index));
    // Remove empty sections defensively
    return sections.where((s) => s.items.isNotEmpty).toList(growable: false);
  }
}
