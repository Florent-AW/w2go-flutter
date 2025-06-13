// core/adapters/supabase/trip_activities_adapter.dart


import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/ports/trip_activities_port.dart';
import '../../domain/models/scored_activity.dart';

class TripActivitiesAdapter implements TripActivitiesPort {
  final SupabaseClient _supabase;

  TripActivitiesAdapter(this._supabase);

  @override
  Future<void> saveFilteredActivities({
    required String tripId,
    required List<ScoredActivity> activities,
    required bool isSuperwow,
  }) async {
    try {
      print('📝 Début sauvegarde - Trip: $tripId - ${activities.length} activités');

      final validActivities = activities.where((a) => a.subcategoryScore > 0).toList();
      print('🔍 ${activities.length - validActivities.length} activités ignorées (score 0)');

      // Avant l'upsert, faire un select pour comparer les données
      final existingRecords = await _supabase
          .from('trip_activities')
          .select()
          .eq('trip_id', tripId)
          .inFilter('activity_id', validActivities.map((a) => a.id).toList());

      print('🔄 ${existingRecords.length} activités existantes trouvées');

      // Préparer les nouvelles données ou mises à jour
      final batch = validActivities.map((activity) {
        // Chercher l'enregistrement existant
        final existing = existingRecords
            .firstWhere(
              (e) => e['activity_id'] == activity.id,
          orElse: () => {}, // Retourne un objet vide au lieu de null
        );

        // Vérifier si une mise à jour est nécessaire
        if (existing.isNotEmpty &&
            existing['total_score'] == activity.totalScore &&
            existing['subcategory_score'] == activity.subcategoryScore &&
            existing['is_superwow'] == isSuperwow) {
          print('⏩ Activité ${activity.id} inchangée');
          return null;  // Skip cette activité
        }

        // Nouvelle activité ou mise à jour nécessaire
        final data = {
          'trip_id': tripId,
          'activity_id': activity.id,
          'planned_date': DateTime.now().toIso8601String(),
          'status': 'suggested',
          'priority': isSuperwow ? 1 : 2,
          'total_score': activity.totalScore,
          'subcategory_score': activity.subcategoryScore,
          'is_superwow': isSuperwow,
          'geohash': activity.activityData['geohash'],
          'user_modified': false,
          'updated_at': DateTime.now().toIso8601String(),
        };

        print('📦 Préparation activité ${activity.id} : $data');
        return data;
      }).whereType<Map<String, dynamic>>().toList();  // Filtrer les null

      if (batch.isEmpty) {
        print('✅ Aucune mise à jour nécessaire');
        return;
      }

      print('💾 Mise à jour/insertion de ${batch.length} activités');
      await _supabase.from('trip_activities').upsert(batch);
      print('✅ Résultat upsert: Succès');

    } catch (e) {
      print('❌ Erreur sauvegarde: $e');
      rethrow;
    }
  }



  @override
  Future<List<ScoredActivity>> getSuperwowActivities(String tripId) async {
    final response = await _supabase
        .from('trip_activities')
        .select('*, activity:activities(*)')
        .eq('trip_id', tripId)
        .eq('is_superwow', true)
        .eq('status', 'suggested');

    return response.map<ScoredActivity>((data) =>
        ScoredActivity.fromJson({
          ...data['activity'],
          'total_score': data['total_score'],
          'subcategory_score': data['subcategory_score'],
          'is_superwow': data['is_superwow'],
        })
    ).toList();
  }
}