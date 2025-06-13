// lib/core/domain/services/empty_trips/neighbor_geohashes.service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../ports/empty_trips/neighbor_geohashes.port.dart';

// lib/core/domain/services/empty_trips/neighbor_geohashes.service.dart

class NeighborGeohashesService implements NeighborGeohashesPort {
  final SupabaseClient _supabase;

  NeighborGeohashesService(this._supabase);

  @override
  Future<void> generateAndSaveNeighbors({
    required String emptyTripId,
    required List<String> traversedGeohashes,
  }) async {
    try {
      print('🔄 Processing neighbors for empty trip: $emptyTripId');
      Map<String, Map<String, dynamic>> neighborsWithClosest = {};

      for (var routeGeohash in traversedGeohashes) {
        final neighbors = await _supabase
            .from('geohash5_distances')
            .select()
            .eq('geohash5_origin', routeGeohash)
            .lte('center_distance_km', 30.0);

        for (var neighbor in neighbors) {
          final neighborGeohash = neighbor['geohash5_neighbor'];
          final distance = (neighbor['center_distance_km'] * 1000).round();

          if (!neighborsWithClosest.containsKey(neighborGeohash) ||
              distance < neighborsWithClosest[neighborGeohash]!['distance_to_route']) {
            neighborsWithClosest[neighborGeohash] = {
              'closest_route_geohash5': routeGeohash,
              'distance_to_route': distance
            };
          }
        }
      }

      if (neighborsWithClosest.isNotEmpty) {
        final dataToUpsert = neighborsWithClosest.entries.map((e) => ({
          'empty_trip_id': emptyTripId,
          'geohash5': e.key,
          'closest_route_geohash5': e.value['closest_route_geohash5'],
          'distance_to_route': e.value['distance_to_route'],
        })).toList();

        await _supabase
            .from('empty_trip_neighbor_geohashes')
            .upsert(dataToUpsert);

        print('✅ Saved ${dataToUpsert.length} unique neighbors');
      }
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getNeighborGeohashes(String emptyTripId) async {
    final response = await _supabase
        .from('empty_trip_neighbor_geohashes')
        .select()
        .eq('empty_trip_id', emptyTripId);

    return Map.fromEntries(
        (response as List).map((n) => MapEntry(
            n['geohash5'] as String,
            {
              'closest_route_geohash5': n['closest_route_geohash5'],
              'distance_to_route': n['distance_to_route']
            }
        ))
    );
  }
}