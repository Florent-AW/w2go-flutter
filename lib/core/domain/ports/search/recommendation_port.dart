// lib/core/domain/ports/search/recommendation_port.dart

import '../../models/search/recommendation/recommendation_query.dart';
import '../../models/search/recommendation/recommendation_result.dart';

/// Port pour les recommandations d'activités
///
/// Interface pure qui sera implémentée par l'adapter Supabase
/// La logique de filtrage est côté backend/Supabase
abstract class RecommendationPort {

  /// Récupère des recommandations d'activités selon une query
  ///
  /// [activityId] : ID de l'activité courante (pour exclusion et contexte)
  /// [query] : Critères de recommandation
  ///
  /// Retourne un RecommendationResult avec le pool d'activités
  Future<RecommendationResult> getRecommendations(
      String activityId,
      RecommendationQuery query,
      {double? userLat, double? userLon}  // ✅ NOUVEAU
      );

}