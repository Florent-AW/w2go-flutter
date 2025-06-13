// core/domain/services/travel_time_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';


class TravelTimeService {
  final SupabaseClient _client;

  TravelTimeService(this._client);

  Future<int> calculateTravelTime(String originGeohash5, String destinationGeohash5) async {
    // Si même geohash5
    if (originGeohash5 == destinationGeohash5) {
      return 15; // 15 minutes
    }

    // Essayer d'abord geohash5_distances
    final geohash5Response = await _client
        .from('geohash5_distances')
        .select()
        .eq('geohash5_origin', originGeohash5)
        .eq('geohash5_neighbor', destinationGeohash5)
        .maybeSingle();

    if (geohash5Response != null) {
      double distance = geohash5Response['center_distance_km'];
      return 15 + (distance.round()); // 15min + 1min/km
    }

    // Sinon, utiliser geohash_neighbors avec geohash4
    String geohash4Origin = originGeohash5.substring(0, 4);
    String geohash4Destination = destinationGeohash5.substring(0, 4);

    final geohash4Response = await _client
        .from('geohash_neighbors')
        .select()
        .eq('geohash', geohash4Origin)
        .eq('neighbor_geohash', geohash4Destination)
        .maybeSingle();

    if (geohash4Response != null) {
      double distance = geohash4Response['distance_km'];
      // Appliquer les règles de temps selon la distance
      return _getTimeForDistance(distance);
    }

    // Par défaut, retourner un temps maximum
    return 150; // 2h30
  }

  int _getTimeForDistance(double distance) {
    if (distance <= 30) return 45;      // 45min
    if (distance <= 50) return 60;      // 1h
    if (distance <= 80) return 90;      // 1h30
    if (distance <= 110) return 120;    // 2h
    return 150;                         // 2h30
  }
}