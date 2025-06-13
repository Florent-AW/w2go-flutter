// lib/features/experience_detail/application/providers/experience_recommendations_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../core/domain/services/shared/activity_recommendation_service.dart';
import '../../../../core/domain/ports/providers/search/recommendation_providers.dart';
import '../../../../features/search/application/state/city_selection_state.dart';

part 'experience_recommendations_provider.g.dart';

/// Provider unifié pour les recommandations d'expériences
///
/// Gère les recommandations pour Activities (Events à venir)
/// Utilise ExperienceItem en clé pour être vraiment unifié
@riverpod
class ExperienceRecommendations extends _$ExperienceRecommendations {
  @override
  Future<List<SearchableActivity>> build(
      String experienceId,  // ✅ Plus générique
      String sectionType,
      ) async {
    try {
      print('🎯 ExperienceRecommendations: $sectionType pour $experienceId');

      final recommendationAdapter = ref.read(recommendationAdapterProvider);

      // ✅ Pour l'instant, on gère que les Activities
      // TODO: Ajouter support Events quand système de recommandations Events sera prêt
      final query = sectionType == 'similar'
          ? ActivityRecommendationService.buildSimilarQuery(experienceId)
          : ActivityRecommendationService.buildNearbyQuery(experienceId);

      final selectedCity = ref.read(selectedCityProvider);

      if (sectionType == 'similar' && selectedCity != null) {
        print('📍 Ville sélectionnée: ${selectedCity.cityName} (${selectedCity.lat}, ${selectedCity.lon})');
      }

      final result = await recommendationAdapter.getRecommendations(
        experienceId,
        query,
        userLat: selectedCity?.lat,
        userLon: selectedCity?.lon,
      );

      // ✅ Mettre à jour le cache global des titres
      if (result.sectionTitle != null && result.sectionTitle!.isNotEmpty) {
        ActivityRecommendationService.setSectionTitle(sectionType, result.sectionTitle!);
      }

      final displayLimit = result.configLimit ?? query.limit ?? 10;
      final sampledActivities = ActivityRecommendationService.sampleFromPool(
        result.activities,
        displayLimit,
      );

      print('✅ ExperienceRecommendations: ${sampledActivities.length} activités pour $sectionType');
      print('🏷️ Titre utilisé: "${result.sectionTitle}"');
      print('📊 Limite JSON: ${result.configLimit}, Pool: ${result.activities.length}');

      return sampledActivities;

    } catch (e, stack) {
      print('❌ ExperienceRecommendations erreur: $e');
      return [];
    }
  }
}