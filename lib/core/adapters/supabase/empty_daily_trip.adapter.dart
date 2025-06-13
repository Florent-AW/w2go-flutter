// lib/core/adapters/supabase/empty_daily_trip.adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/ports/empty_trips/empty_daily_trip.port.dart';
import '../../domain/models/trip_designer/empty_trips/empty_daily_trip.dart';
import '../../common/enums/trip_enums.dart';

class EmptyDailyTripAdapter implements EmptyDailyTripPort {
  final SupabaseClient _supabase;

  EmptyDailyTripAdapter(this._supabase);

  EmptyDailyTrip _convertResponseToEmptyTrip(Map<String, dynamic> response) {
    return EmptyDailyTrip(
      id: response['id'],
      type: response['type'] == 'half_day' ? DailyTripType.half_day : DailyTripType.full_day,
      departureGeohash5: response['departure_geohash5'],
      arrivalGeohash5: response['arrival_geohash5'],
      sw1Id: response['sw1_id'],
      sw2Id: response['sw2_id'],
      traversedGeohashes: List<String>.from(response['traversed_geohashes']),
      routePolyline: response['route_polyline'],
      createdAt: DateTime.parse(response['created_at']),
      totalDuration: response['total_duration'],
      totalDistance: response['total_distance'],
    );
  }

  @override
  Future<EmptyDailyTrip?> findExistingEmptyTrip({
    required DailyTripType type,
    required String departureGeohash5,
    required String arrivalGeohash5,
    required String sw1Id,
    String? sw2Id,
  }) async {
    try {
      var query = _supabase
          .from('empty_daily_trips')
          .select()
          .eq('type', type.toString().split('.').last)
          .eq('departure_geohash5', departureGeohash5)
          .eq('arrival_geohash5', arrivalGeohash5)
          .eq('sw1_id', sw1Id);

      query = sw2Id == null
          ? query.filter('sw2_id', 'is', null)
          : query.eq('sw2_id', sw2Id);

      final response = await query;

      if (response.isEmpty) return null;

      return _convertResponseToEmptyTrip(response[0]);
    } catch (e) {
      print('❌ Erreur recherche empty trip: $e');
      rethrow;
    }
  }

  @override
  Future<EmptyDailyTrip> getEmptyTrip(String emptyTripId) async {
    try {
      print('🔍 Récupération empty trip: $emptyTripId');
      final response = await _supabase
          .from('empty_daily_trips')
          .select()
          .eq('id', emptyTripId)
          .single();

      return _convertResponseToEmptyTrip(response);
    } catch (e) {
      print('❌ Erreur récupération empty trip: $e');
      rethrow;
    }
  }

  @override
  Future<EmptyDailyTrip> createEmptyTrip({
    required DailyTripType type,
    required String departureGeohash5,
    required String arrivalGeohash5,
    required String sw1Id,
    String? sw2Id,
    required List<String> traversedGeohashes,
    required String routePolyline,
    required int totalDuration,
    required int totalDistance,
  }) async {
    try {
      final emptyTrip = EmptyDailyTrip(
        id: const Uuid().v4(),
        type: type,
        departureGeohash5: departureGeohash5,
        arrivalGeohash5: arrivalGeohash5,
        sw1Id: sw1Id,
        sw2Id: sw2Id,
        traversedGeohashes: traversedGeohashes,
        routePolyline: routePolyline,
        createdAt: DateTime.now(),
        totalDuration: totalDuration,
        totalDistance: totalDistance,
      );

      await _supabase.from('empty_daily_trips').insert({
        ...emptyTrip.toJson(),
        'total_distance': emptyTrip.totalDistance,
        'total_duration': emptyTrip.totalDuration,
      });

      return emptyTrip;
    } catch (e) {
      print('❌ Erreur création empty trip: $e');
      rethrow;
    }
  }
}