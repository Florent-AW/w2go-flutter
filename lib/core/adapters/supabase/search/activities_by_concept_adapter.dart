// core/adapters/supabase/search/activities_by_concept_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/models/activity/base/activity_base.dart';
import '../../../domain/models/activity/search/searchable_activity.dart';
import '../../../domain/models/search/concept_types.dart';
import '../../../domain/pagination/paginated_result.dart';
import '../../../domain/ports/search/activities_by_concept_port.dart';

class ActivitiesByConceptAdapter implements ActivitiesByConceptPort {
  final SupabaseClient _client;

  ActivitiesByConceptAdapter(this._client);

  @override
  Future<PaginatedResult<SearchableActivity>> list({
    required String conceptId,
    required ConceptType conceptType,
    required double lat,
    required double lon,
    double radiusKm = 50,
    SortMode sort = SortMode.distance,
    int limit = 20,
    int offset = 0,
  }) async {
    final rpcLimit = limit + 1; // fetch one extra to detect hasMore
    final response = await _client.rpc('fn_list_activities_by_concept', params: {
      'p_concept_id': conceptId,
      'p_concept_type': conceptType.asParam,
      'p_lat': lat,
      'p_lon': lon,
      'p_radius_km': radiusKm,
      'p_limit': rpcLimit,
      'p_offset': offset,
      'p_sort': sort.asParam,
    });

    final List data = (response ?? []) as List;

    int totalCount = 0;
    final List<SearchableActivity> items = [];

    for (int i = 0; i < data.length; i++) {
      final row = (data[i] as Map).cast<String, dynamic>();
      if (i == 0) {
        totalCount = (row['total_count'] as num?)?.toInt() ?? 0;
      }

      final sub = row['subcategory'] is Map
          ? (row['subcategory'] as Map).cast<String, dynamic>()
          : null;
      final imageUrl = row['image_url'] as String?; // preserve null for UI placeholder
      final distance = (row['distance_km'] as num?)?.toDouble();

      final base = ActivityBase(
        id: row['id'].toString(),
        name: (row['name'] ?? '').toString(),
        description: null,
        latitude: (row['latitude'] as num?)?.toDouble() ?? 0.0, // ensure RPC selects these columns
        longitude: (row['longitude'] as num?)?.toDouble() ?? 0.0,
        categoryId: (row['category_id'] ?? '').toString(),
        subcategoryId: row['subcategory_id']?.toString(),
        city: (row['city'] ?? '').toString(),
        imageUrl: imageUrl,
        ratingAvg: (row['rating_avg'] as num?)?.toDouble() ?? 0.0,
        ratingCount: (row['rating_count'] as num?)?.toInt() ?? 0,
      );

      items.add(
        SearchableActivity(
          base: base,
          categoryName: null, // not provided explicitly
          subcategoryName: sub?['name']?.toString(),
          subcategoryIcon: sub?['icon']?.toString(),
          distance: distance,
          city: base.city,
          mainImageUrl: imageUrl,
        ),
      );
    }

    final hasMore = items.length > limit;
    final sliced = hasMore ? items.sublist(0, limit) : items;

    return PaginatedResult(
      items: sliced,
      hasMore: hasMore,
      totalCount: totalCount,
      nextOffset: offset + (hasMore ? limit : sliced.length),
    );
  }
}
