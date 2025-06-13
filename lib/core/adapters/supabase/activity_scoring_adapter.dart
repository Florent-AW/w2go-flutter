// core/adapters/supabase/activity_scoring_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/ports/activity_scoring_port.dart';
import '../../domain/models/trip_designer/scoring/scoring_activity.dart';
import '../../domain/models/trip_designer/processing/activity_processing_model.dart';
import '../../domain/services/scoring_service.dart';

class ActivityScoringAdapter implements ActivityScoringPort {
  final SupabaseClient _client;
  final ScoringService _scoringService;

  ActivityScoringAdapter(this._client) : _scoringService = ScoringService();

  @override
  Future<List<ScoredActivity>> scoreActivities(String userId, List<ActivityForProcessing> activities) async {
    try {
      print('🎯 Début du scoring des activités pour l\'utilisateur: $userId');

      // 1. Récupérer les préférences utilisateur
      final preferences = await getUserPreferences(userId);

      // 2. Récupérer les scores existants en cache
      final existingScores = await _getCachedScores(userId, activities.map((a) => a.id).toList(), activities);
      final results = <ScoredActivity>[];

      for (var activity in activities) {
        // Vérifier si un score en cache existe et est toujours valide
        if (existingScores.containsKey(activity.id)) {
          print('✅ Score en cache trouvé pour ${activity.name}');
          results.add(existingScores[activity.id]!);
          continue;
        }

        print('🔄 Calcul du score pour ${activity.name}');

        // Calculer les nouveaux scores
        final subcategoryScore = preferences[activity.subcategoryId] ?? 0.0;
        final totalScore = _scoringService.calculateTotalScore(activity, subcategoryScore);
        final isSuperWow = _scoringService.isSuperWow(totalScore, subcategoryScore);
        print('🎯 Activité ${activity.id}: score total=${totalScore}, subcategory=${subcategoryScore}, SuperWow=${isSuperWow}');


        // Sauvegarder en cache
        await _saveScore(
          userId,
          activity.id,
          totalScore,
          subcategoryScore,
          isSuperWow,
        );

        results.add(ScoredActivity(
          activity: activity,
          totalScore: totalScore,
          subcategoryScore: subcategoryScore,
          isSuperWow: isSuperWow,
        ));
      }

      print('✅ Scoring terminé: ${results.length} activités traitées');
      return results;
    } catch (e) {
      print('❌ Erreur lors du scoring: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, double>> getUserPreferences(String userId) async {
    try {
      final response = await _client
          .from('user_subcategory_preferences')
          .select()
          .eq('user_id', userId);

      final preferences = <String, double>{};
      for (var pref in response) {
        preferences[pref['subcategory_id']] = pref['score']?.toDouble() ?? 0.0;
      }

      return preferences;
    } catch (e) {
      print('❌ Erreur lors de la récupération des préférences: $e');
      rethrow;
    }
  }

  Future<Map<String, ScoredActivity>> _getCachedScores(
      String userId,
      List<String> activityIds,
      List<ActivityForProcessing> activities  // Ajout du paramètre
      ) async {
    try {
      final response = await _client
          .from('user_activities_score')
          .select()
          .eq('user_id', userId)
          .inFilter('activity_id', activityIds);

      final cachedScores = <String, ScoredActivity>{};
      for (var score in response) {
        // On ne prend que les scores qui ont encore une période de validité
        if (score['superwow_validity_period'] != null &&
            DateTime.parse(score['superwow_validity_period']).isBefore(DateTime.now())) {
          continue;
        }

        cachedScores[score['activity_id']] = ScoredActivity(
          activity: activities.firstWhere((a) => a.id == score['activity_id']),
          totalScore: score['total_score']?.toDouble() ?? 0.0,
          subcategoryScore: score['subcategory_score']?.toDouble() ?? 0.0,
          isSuperWow: score['is_superwow'] ?? false,
        );
      }

      return cachedScores;
    } catch (e) {
      print('❌ Erreur lors de la récupération des scores en cache: $e');
      return {};
    }
  }

  Future<void> _saveScore(
      String userId,
      String activityId,
      double totalScore,
      double subcategoryScore,
      bool isSuperWow,
      ) async {
    try {
      await _client.from('user_activities_score').upsert({
        'user_id': userId,
        'activity_id': activityId,
        'total_score': totalScore,
        'subcategory_score': subcategoryScore,
        'is_superwow': isSuperWow,
        'superwow_validity_period': isSuperWow
            ? DateTime.now().add(Duration(days: 7)).toIso8601String()
            : null,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde du score: $e');
      rethrow;
    }
  }
}