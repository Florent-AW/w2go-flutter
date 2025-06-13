// lib/core/domain/services/shared/activity_recommendation_service.dart

import 'dart:math';
import '../../models/search/recommendation/recommendation_query.dart';
import '../../models/activity/search/searchable_activity.dart';

/// Service métier pour les recommandations d'activités
///
/// Service statique pur, sans dépendances externes
/// Gère la construction des queries et le sampling client
class ActivityRecommendationService {
  static final Map<String, String> _sectionTitles = {};

  /// Construit une query pour les activités similaires
  static RecommendationQuery buildSimilarQuery(String currentActivityId) {
    return RecommendationQuery(
      sectionType: 'similar',
      excludeCurrentActivity: true,
      rotation: 'daily',
      randomSample: true,
    );
  }

  /// Construit une query pour les activités à proximité
  static RecommendationQuery buildNearbyQuery(String currentActivityId) {
    return RecommendationQuery(
      sectionType: 'nearby',
      excludeCurrentActivity: true,
      rotation: 'daily',
      randomSample: true,
    );
  }

  /// Échantillonne aléatoirement des activités depuis un pool élargi
  ///
  /// Garantit la variété avec seed stable quotidien + shuffle client
  /// Pool backend (30) → Seed stable → Shuffle → Take limit (10)
  static List<SearchableActivity> sampleFromPool(
      List<SearchableActivity> pool,
      int targetLimit,
      ) {
    if (pool.isEmpty) return [];
    if (pool.length <= targetLimit) return pool;

    // ✅ NOUVEAU : Seed stable quotidien côté client
    final today = DateTime.now();
    final dailySeed = (today.year * 10000 + today.month * 100 + today.day) % 1000;
    final random = Random(dailySeed);

    // Shuffle avec seed stable (même jour = même ordre)
    final shuffled = List<SearchableActivity>.from(pool);
    shuffled.shuffle(random);

    final result = shuffled.take(targetLimit).toList();
    print('✅ SAMPLING: ${result.length} activités sélectionnées (seed: $dailySeed)');

    return result;
  }

  /// Valide qu'une query de recommandation est cohérente
  static bool isValidQuery(RecommendationQuery query) {
    if (query.sectionType != 'similar' && query.sectionType != 'nearby') return false;
    if (query.minRating != null && (query.minRating! < 0 || query.minRating! > 5)) return false;
    if (query.maxDistanceKm != null && query.maxDistanceKm! <= 0) return false;

    return true;
  }

  /// ✅ NOUVEAU : Met à jour le titre pour un type de section
  static void setSectionTitle(String sectionType, String title) {
    _sectionTitles[sectionType] = title;
  }

  /// Génère un titre approprié selon le type de section
  static String getSectionTitle(String sectionType) {
    // ✅ MODIFIÉ : Vérifier d'abord le cache
    if (_sectionTitles.containsKey(sectionType)) {
      return _sectionTitles[sectionType]!;
    }

    // Fallback si pas en cache
    switch (sectionType) {
      case 'similar':
        return 'Activités similaires';
      case 'nearby':
        return 'À proximité';
      default:
        return 'Recommandations';
    }
  }


}