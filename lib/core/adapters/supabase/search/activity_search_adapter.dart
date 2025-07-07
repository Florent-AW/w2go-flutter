// lib/core/adapters/supabase/search/activity_search_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid_value.dart';
import '../../../domain/models/activity/search/searchable_activity.dart';
import '../../../domain/models/search/activity_filter.dart';
import '../../../domain/ports/search/activity_search_port.dart';

class ActivitySearchAdapter implements ActivitySearchPort {
  final SupabaseClient _client;

  ActivitySearchAdapter(this._client);

  @override
  Future<List<SearchableActivity>> getActivitiesWithFilter(
      ActivityFilter filter, {
        required double latitude,
        required double longitude,
        String? cityId,
      }) async {
    try {
      // Utiliser la section_id et la position pour appeler la nouvelle RPC
      final String sectionId = filter.sectionId!;

// Typer explicitement le map comme dynamic
      final Map<String, dynamic> params = {
        'p_section_id': sectionId,
        'p_latitude': latitude,
        'p_longitude': longitude,
        'p_limit': filter.limit,
        'p_offset': filter.offset,
      };

// Ajouter les paramètres conditionnellement
      if (filter.categoryId != null) {
        params['p_category_id'] = filter.categoryId!;
      }
      if (filter.subcategoryId != null) {
        params['p_subcategory_id'] = filter.subcategoryId!;
      }

      print('📝 Appel get_activities_list avec params: $params');

      // Appel à la RPC Supabase optimisée
      final response = await _client.rpc('get_activities_list', params: params);

      print('📊 Nombre d\'activités reçues: ${response.length}');

      // Mapper les résultats
      final List<SearchableActivity> activities = [];
      for (final item in response) {
        try {
          activities.add(SearchableActivity.fromSupabase(item,
              distanceFromSearch: item['distance']?.toDouble()));
        } catch (e) {
          print('⚠️ Erreur lors du mapping d\'une activité: $e');
        }
      }

      print('✅ Traitement terminé: ${activities.length} activités');
      return activities;
    } catch (e) {
      print('❌ Erreur dans getActivitiesWithFilter: $e');
      rethrow; // Propager l'erreur pour permettre un meilleur traitement en amont
    }
  }

  // Méthode de compatibilité avec l'ancienne interface - simplifiée
  @override
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
  }) async {
    // Convertir les paramètres en ActivityFilter pour utiliser la méthode principale
    final filter = ActivityFilter(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      isWow: isWow,
      maxDistanceKm: maxDistance,
      minRating: minRating,
      minRatingCount: minRatingCount,
      maxRatingCount: maxRatingCount,
      kidFriendly: kidFriendly,
      orderBy: orderBy ?? 'rating_avg',
      orderDirection: orderDirection ?? 'DESC',
      limit: limit ?? 20,
      // Si rawFilters contient une section_id, l'utiliser
      sectionId: rawFilters?['sectionId'] ?? rawFilters?['section_id'],
    );

    return getActivitiesWithFilter(
      filter,
      latitude: latitude,
      longitude: longitude,
      cityId: cityId,
    );
  }
}