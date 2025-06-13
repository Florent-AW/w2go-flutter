// lib/core/adapters/supabase/search/recommendation_adapter.dart

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/ports/search/recommendation_port.dart';
import '../../../domain/models/search/recommendation/recommendation_query.dart';
import '../../../domain/models/search/recommendation/recommendation_result.dart';
import '../../../domain/models/activity/search/searchable_activity.dart';
import '../../../domain/models/activity/base/activity_base.dart';
import '../cache/supabase_cache_adapter.dart';

/// Adapter Supabase pour les recommandations d'activités avec cache intégré
class RecommendationAdapter implements RecommendationPort {
  final SupabaseClient _client;
  final SupabaseCacheAdapter _cache;
  String? _lastSectionTitle;
  int? _lastConfigLimit;

  RecommendationAdapter(this._client)
      : _cache = SupabaseCacheAdapter(_client);

  @override
  Future<RecommendationResult> getRecommendations(
      String activityId,
      RecommendationQuery query,
      {double? userLat, double? userLon}
      ) async {
    try {
      print('🔍 RecommendationAdapter: ${query.sectionType} pour activité $activityId');

      // ✅ CACHE : Construire la clé
      final cacheKey = await _buildCacheKey(
          activityId,
          query.sectionType,
          userLat: userLat,
          userLon: userLon
      );

      // ✅ CACHE : Essayer de récupérer depuis le cache
      final cached = await _cache.get(cacheKey);
      if (cached != null) {
        try {
          final cachedResult = RecommendationResult.fromJson(jsonDecode(cached));

          // ✅ Restaurer les métadonnées dans l'adapter
          _lastSectionTitle = cachedResult.sectionTitle;
          _lastConfigLimit = cachedResult.configLimit;

          return cachedResult.copyWith(
            cacheKey: '$cacheKey (cached)',
            generatedAt: DateTime.now(),
          );
        } catch (e) {
          print('❌ CACHE PARSE ERROR: $e');
          // Continue avec requête fraîche si cache corrompu
        }
      }

      // ✅ CACHE MISS : Récupérer depuis la DB
      print('🗄️ CACHE MISS: $cacheKey');
      final activities = await _getRecommendationsFromDB(
        activityId,
        query.sectionType,
        userLat: userLat,
        userLon: userLon,
      );

      final result = RecommendationResult(
        activities: activities,
        totalFound: activities.length,
        sectionType: query.sectionType,
        sectionTitle: _lastSectionTitle,
        configLimit: _lastConfigLimit,
        cacheKey: cacheKey,
        generatedAt: DateTime.now(),
      );

      // ✅ CACHE : Stocker le résultat (async, ne pas attendre)
      _cacheResult(cacheKey, result);

      return result;

    } catch (e, stack) {
      print('❌ RecommendationAdapter erreur: $e');
      return RecommendationResult(
        activities: [],
        totalFound: 0,
        sectionType: query.sectionType,
        sectionTitle: null,
        cacheKey: null,
        generatedAt: DateTime.now(),
      );
    }
  }

  /// ✅ NOUVEAU : Construit la clé de cache avec bucketisation intelligente
  Future<String> _buildCacheKey(
      String activityId,
      String sectionType,
      {double? userLat, double? userLon}
      ) async {
    final rotationKey = DateFormat('yyyyMMdd').format(DateTime.now());

    switch (sectionType) {
      case 'nearby':
      // Nearby : Simple clé basée sur l'activité + rotation quotidienne
        return 'nearby_${activityId}_$rotationKey';

      case 'similar':
      // Similar : Bucketisation géographique + subcategory
        if (userLat == null || userLon == null) {
          throw ArgumentError('User coordinates required for similar recommendations');
        }

        // ✅ Bucketisation à 0.1° (≈ 10km de précision)
        final latBucket = (userLat * 10).round();
        final lonBucket = (userLon * 10).round();

        // ✅ Récupérer subcategoryId pour la clé
        final subcategoryId = await _getActivitySubcategoryId(activityId);
        final subcatKey = subcategoryId?.substring(0, 8) ?? 'unknown'; // Raccourcir l'UUID

        return 'similar_${subcatKey}_lat${latBucket}_lon${lonBucket}_$rotationKey';

      default:
        throw ArgumentError('Unknown section type: $sectionType');
    }
  }

  /// ✅ NOUVEAU : Récupère le subcategoryId d'une activité (avec cache local)
  static final Map<String, String?> _subcategoryCache = {};

  Future<String?> _getActivitySubcategoryId(String activityId) async {
    // Cache local pour éviter requêtes répétées
    if (_subcategoryCache.containsKey(activityId)) {
      return _subcategoryCache[activityId];
    }

    try {
      final response = await _client
          .from('activities')
          .select('subcategory_id')
          .eq('id', activityId)
          .single();

      final subcategoryId = response['subcategory_id'] as String?;
      _subcategoryCache[activityId] = subcategoryId;

      return subcategoryId;
    } catch (e) {
      print('❌ Error fetching subcategory for activity $activityId: $e');
      return null;
    }
  }

  /// ✅ NOUVEAU : Stocke le résultat en cache (asynchrone)
  void _cacheResult(String cacheKey, RecommendationResult result) {
    // Stockage asynchrone pour ne pas bloquer la réponse
    Future.microtask(() async {
      try {
        final json = jsonEncode(result.toJson());
        await _cache.set(cacheKey, json, const Duration(hours: 24));
        print('💾 CACHE STORED: $cacheKey');
      } catch (e) {
        print('❌ CACHE STORAGE ERROR: $cacheKey - $e');
        // Fail silently - cache n'est pas critique
      }
    });
  }

  /// Récupère les recommandations via RPC unifié + configuration table
  Future<List<SearchableActivity>> _getRecommendationsFromDB(
      String activityId,
      String sectionType,
      {double? userLat, double? userLon}
      ) async {
    try {
      final params = {
        'p_activity_id': activityId,
        'p_section_type': sectionType,
      };

      if (userLat != null && userLon != null) {
        params['p_user_lat'] = userLat.toString();
        params['p_user_lon'] = userLon.toString();
      }

      final response = await _client.rpc(
        'get_activity_recommendations',
        params: params,
      ).select();

      if (response == null) return [];

      final List<dynamic> data = response as List<dynamic>;

      // ✅ Stocker le titre ET la limite de la première ligne
      if (data.isNotEmpty) {
        _lastSectionTitle = data.first['section_title'];
        _lastConfigLimit = data.first['config_limit'];
      }

      return data
          .cast<Map<String, dynamic>>()
          .map((item) => _mapToSearchableActivity(item))
          .toList();

    } catch (e) {
      print('❌ _getRecommendationsFromDB erreur: $e');
      return [];
    }
  }

  /// Mappe les données RPC vers SearchableActivity
  SearchableActivity _mapToSearchableActivity(Map<String, dynamic> data) {
    return SearchableActivity(
      base: ActivityBase(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        description: data['description'],
        latitude: (data['latitude'] ?? 0.0).toDouble(),
        longitude: (data['longitude'] ?? 0.0).toDouble(),
        categoryId: data['category_id'] ?? '',
      ),
      mainImageUrl: data['main_image_url'],
      categoryName: data['category_name'],
      subcategoryName: data['subcategory_name'],
      subcategoryIcon: data['subcategory_icon'],
      city: data['city'],
      // Distance pour nearby (optionnel)
      approxDistanceKm: data['distance_km']?.toDouble(),
    );
  }
}