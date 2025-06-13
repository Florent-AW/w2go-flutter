// core/adapters/supabase/activity_processing_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/ports/activity_processing_port.dart';
import '../../domain/models/trip_designer/processing/activity_processing_model.dart';
import '../../domain/models/trip_designer/trip/trip_model.dart';
import '../../domain/designer/filters/travel_group_filter.dart';
import '../../domain/designer/filters/time_filter.dart';
import '../../domain/ports/activity_hours_port.dart';
import '../../domain/services/travel_time_service.dart';
import '../../common/exceptions/exceptions.dart';
import '../../common/enums/trip_enums.dart';
import '../supabase/activity_hours_adapter.dart';

class ActivityProcessingAdapter implements ActivityProcessingPort {
  final SupabaseClient _supabase;
  final ActivityHoursPort _hoursService;


  ActivityProcessingAdapter(SupabaseClient supabase) :
        _supabase = supabase,
        _hoursService = ActivityHoursAdapter(supabase);

  @override
  Future<List<ActivityForProcessing>> getActivitiesForTrip(String tripId) async {
    try {
      // 1. Récupérer le trip
      final tripResponse = await _supabase
          .from('trips')
          .select('''
            *,
            cities!trips_departure_city_id_fkey (*)
          ''')
          .eq('id', tripId)
          .single();

      final trip = Trip.fromJson(tripResponse);
      print('🎯 Types d\'exploration: ${trip.activeExplorationType}');

      // 2. Calculer la distance maximale
      final maxDistance = _getMaxDistance(trip.activeExplorationType);
      print('📏 Distance maximale calculée: $maxDistance km');

      // 3. Récupérer les geohash voisins
      final geohash4 = trip.departureGeohash5?.substring(0, 4);
      print('🗺️ Geohash4 de départ: $geohash4');

      final neighbors = await getGeohashNeighbors(geohash4 ?? '', maxDistance);
      print('🔍 Geohash voisins trouvés: ${neighbors.keys.toList()}');

      final allGeohashes = [geohash4, ...neighbors.values.expand((e) => e).toList()];
      print('🎯 Recherche des activités dans les geohash: $allGeohashes');

      final response = await _supabase
          .from('activities')
          .select()
          .inFilter('geohash_4', allGeohashes);

      print('📍 Nombre d\'activités trouvées: ${response.length}');

      return response.map((json) => ActivityForProcessing.fromJson(json)).toList();
    } catch (e) {
      print('❌ Erreur dans getActivitiesForTrip: $e');
      throw DataException('Erreur lors de la récupération des activités: $e');
    }
  }

  double _getMaxDistance(List<ExplorationType> types) {
    double maxDist = 0;
    print('🔄 Calcul de la distance maximale pour les types: ${types.map((t) => t.value).toList()}');
    for (var type in types) {
      final dist = type.maxDistance;
      print('  - Type ${type.value}: $dist km');
      if (dist > maxDist) maxDist = dist;
    }
    print('  → Distance max retenue: $maxDist km');
    return maxDist;
  }

  @override
  Future<List<ActivityForProcessing>> getFilteredActivities({
    required String tripId,
    required Trip trip,
    required List<ActivityForProcessing> activities,
  }) async {
    try {
      print('🎯 Début du filtrage des activités');
      print('Nombre d\'activités avant filtrage: ${activities.length}');

      // Créer et appliquer le filtre de temps
      final timeFilter = TimeFilter(
        tripStartDate: trip.startDate,
        tripEndDate: trip.endDate,
        dailyHours: trip.activityHours.daily_hours,
        hoursService: _hoursService,
        departureGeohash5: trip.departureGeohash5 ?? '',  // Ajout
        travelTimeService: TravelTimeService(_supabase),   // Ajout
      );

      final timeFilteredActivities = await timeFilter.apply(activities);
      print('Nombre d\'activités après filtre temporel: ${timeFilteredActivities.length}');

      // Créer et appliquer le filtre de groupe
      final groupFilter = TravelGroupFilter(trip.travelGroup);
      final filteredActivities = await groupFilter.apply(timeFilteredActivities);
      print('Nombre d\'activités après tous les filtres: ${filteredActivities.length}');

      return filteredActivities;
    } catch (e) {
      print('❌ Erreur lors du filtrage: $e');
      throw DataException('Erreur lors du filtrage des activités: $e');
    }
  }

  @override
  double getExplorationRadius(String explorationType) {
    return ExplorationType.values
        .firstWhere(
            (e) => e.value == explorationType,
        orElse: () => ExplorationType.around_me
    ).maxDistance;
  }

  @override
  Future<Map<String, List<String>>> getGeohashNeighbors(
      String geohash4, double maxDistance) async {
    try {
      print('🔍 Recherche des voisins pour le geohash: $geohash4');
      print('📏 Distance maximale: $maxDistance km');

      final response = await _supabase
          .from('geohash_neighbors')
          .select()
          .eq('geohash', geohash4)
          .lte('distance_km', maxDistance)
          .order('distance_km');

      print('📥 Réponse brute: $response');

      Map<String, List<String>> neighbors = {};
      neighbors[geohash4] = [];

      for (var row in response) {
        final neighborHash = row['neighbor_geohash'] as String;
        final neighbor4 = neighborHash.substring(0, 4);

        print('🔄 Ajout du voisin: $neighbor4');
        neighbors[geohash4]?.add(neighbor4);
      }

      print('✅ Voisins trouvés: ${neighbors.values.expand((e) => e).toList()}');
      return neighbors;
    } catch (e) {
      print('❌ Erreur dans getGeohashNeighbors: $e');
      throw DataException('Erreur lors de la récupération des geohash voisins: $e');
    }
  }
}
