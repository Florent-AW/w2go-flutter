// core/domain/ports/activity_processing_port.dart

import '../models/trip_designer/processing/activity_processing_model.dart';
import '../models/trip_designer/trip/trip_model.dart';

abstract class ActivityProcessingPort {
  /// Récupère les activités brutes dans la zone du voyage
  Future<List<ActivityForProcessing>> getActivitiesForTrip(String tripId);

  /// Récupère les activités avec les distances par rapport au geohash de départ
  Future<Map<String, List<String>>> getGeohashNeighbors(String geohash4, double maxDistance);

  /// Applique les filtres et retourne les activités éligibles
  Future<List<ActivityForProcessing>> getFilteredActivities({
    required String tripId,
    required Trip trip,
    required List<ActivityForProcessing> activities,
  });

  /// Récupère le rayon de recherche basé sur le type d'exploration
  double getExplorationRadius(String explorationType);
}