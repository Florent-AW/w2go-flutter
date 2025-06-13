// lib/core/domain/services/empty_trips/empty_trip_generation.service.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dart_geohash/dart_geohash.dart';
import '../../../../common/enums/trip_enums.dart';
import '../../../models/trip_designer/empty_trips/empty_daily_trip.dart';
import '../../../models/trip_designer/empty_trips/value_objects/generation_result.dart';
import '../../../models/trip_designer/empty_trips/value_objects/superwow_pair.dart';
import '../../../models/scored_activity.dart';
import '../../../ports/empty_trips/empty_daily_trip.port.dart';
import '../../../ports/empty_trips/route_optimization.port.dart';
import '../../../ports/empty_trips/superwow_management.port.dart';
import '../../../ports/empty_trips/neighbor_geohashes.port.dart';
import '../../../../common/exceptions/empty_trip_generation_exception.dart';


class EmptyTripGenerationService {
  final SuperWowManagementPort _superwowPort;
  final RouteOptimizationPort _routePort;
  final EmptyDailyTripPort _emptyTripPort;
  final NeighborGeohashesPort _neighborGeohashesService;
  final SupabaseClient _supabase;

  EmptyTripGenerationService(
      this._superwowPort,
      this._routePort,
      this._emptyTripPort,
      this._neighborGeohashesService,
      this._supabase);

  Future<EmptyTripGenerationResult> generateEmptyTrips(String tripId) async {
    try {
      print('🔄 Début de la génération des empty trips');
      final errors = <String>[];

      final tripInfo = await _getTripInfo(tripId);
      final superWows = await _superwowPort.getTripSuperWows(tripId);
      final optimizedPairs = await _superwowPort.generateOptimizedPairs(
        tripId,
        superWows,
        _getLatLngFromGeohash(tripInfo['departure_geohash5']),
      );

      final halfDayResults = await _generateHalfDayTrips(tripInfo, superWows);
      final fullDayResults = await _generateFullDayTrips(
          tripInfo, optimizedPairs);

      return EmptyTripGenerationResult(
        halfDayTrips: halfDayResults.$1,
        fullDayTrips: fullDayResults.$1,
        departureGeohash5: tripInfo['departure_geohash5'],
        errors: [...halfDayResults.$2, ...fullDayResults.$2],
      );
    } catch (e) {
      print('❌ Erreur génération empty trips: $e');
      throw EmptyTripGenerationException(
          'Erreur lors de la génération des empty trips: $e');
    }
  }

  Future<(List<EmptyDailyTrip>, List<String>)> _generateHalfDayTrips(
      Map<String, dynamic> tripInfo,
      List<ScoredActivity> superWows,) async {
    final emptyTrips = <EmptyDailyTrip>[];
    final errors = <String>[];

    for (final sw in superWows) {
      final swLocation = LatLng(
        sw.activityData['latitude'],
        sw.activityData['longitude'],
      );

      final result = await _generateEmptyTripsCommon(
        type: DailyTripType.half_day,
        departureGeohash5: tripInfo['departure_geohash5'],
        sw1Id: sw.id,
        waypoints: [swLocation],
      );

      emptyTrips.addAll(result.$1);
      errors.addAll(result.$2);
    }

    return (emptyTrips, errors);
  }

  Future<(List<EmptyDailyTrip>, List<String>)> _generateFullDayTrips(
      Map<String, dynamic> tripInfo,
      List<SuperWowPair> optimizedPairs,) async {
    final emptyTrips = <EmptyDailyTrip>[];
    final errors = <String>[];

    for (final pair in optimizedPairs) {
      final result = await _generateEmptyTripsCommon(
        type: DailyTripType.full_day,
        departureGeohash5: tripInfo['departure_geohash5'],
        sw1Id: pair.sw1Id,
        sw2Id: pair.sw2Id,
        waypoints: [pair.sw1Location, pair.sw2Location],
      );

      emptyTrips.addAll(result.$1);
      errors.addAll(result.$2);
    }

    return (emptyTrips, errors);
  }

  Future<(List<EmptyDailyTrip>, List<String>)> _generateEmptyTripsCommon({
    required DailyTripType type,
    required String departureGeohash5,
    required String sw1Id,
    String? sw2Id,
    required List<LatLng> waypoints,
  }) async {
    final errors = <String>[];
    try {
      final existingTrip = await _emptyTripPort.findExistingEmptyTrip(
        type: type,
        departureGeohash5: departureGeohash5,
        arrivalGeohash5: departureGeohash5,
        sw1Id: sw1Id,
        sw2Id: sw2Id,
      );

      if (existingTrip != null) {
        return (<EmptyDailyTrip>[existingTrip], errors);
      }

      final departurePoint = _getLatLngFromGeohash(departureGeohash5);
      final arrivalPoint = LatLng(
          departurePoint.latitude + 0.001,
          departurePoint.longitude + 0.001
      );

      final route = await _routePort.getOptimizedRoute(
        departurePoint,
        arrivalPoint,
        waypoints,
      );

      final newTrip = await _emptyTripPort.createEmptyTrip(
        type: type,
        departureGeohash5: departureGeohash5,
        arrivalGeohash5: departureGeohash5,
        sw1Id: sw1Id,
        sw2Id: sw2Id,
        traversedGeohashes: route['traversed_geohashes'],
        routePolyline: route['polyline'],
        totalDistance: route['distance'],
        totalDuration: route['duration'],
      );

      print('🚀 About to generate neighbors');
      print('  Empty Trip ID: ${newTrip.id}');
      print('  Traversed geohashes: ${route['traversed_geohashes']}');

      await _neighborGeohashesService.generateAndSaveNeighbors(
        emptyTripId: newTrip.id,
        traversedGeohashes: route['traversed_geohashes'],
      );

      return (<EmptyDailyTrip>[newTrip], errors);
    } catch (e) {
      final error = 'Erreur génération ${type.name} pour SW$sw1Id${sw2Id != null
          ? "-$sw2Id"
          : ""}: $e';
      print('❌ $error');
      errors.add(error);
      return (<EmptyDailyTrip>[], errors);
    }
  }

  int _calculateTotalDistance(List? legs) {
    if (legs == null || legs.isEmpty) return 0;
    return legs.fold<int>(
        0, (sum, leg) => sum + (leg['distance']?['value'] as int? ?? 0));
  }

  int _calculateTotalDuration(List? legs) {
    if (legs == null || legs.isEmpty) return 0;
    return legs.fold<int>(
        0, (sum, leg) => sum + (leg['duration']?['value'] as int? ?? 0));
  }

  Future<Map<String, dynamic>> _getTripInfo(String tripId) async {
    final response = await _supabase
        .from('trips')
        .select('departure_geohash5, active_exploration_types')
        .eq('id', tripId)
        .single();

    if (response['departure_geohash5'] == null) {
      throw EmptyTripGenerationException('Geohash de départ manquant');
    }
    return response;
  }

  LatLng _getLatLngFromGeohash(String geohash5) {
    try {
      final geohasher = GeoHasher();
      final coordinates = geohasher.decode(geohash5);
      // Inverser coordinates[0] et coordinates[1] car GeoHasher retourne [lng, lat]
      final lat = double.parse(coordinates[1].toStringAsFixed(6));
      final lng = double.parse(coordinates[0].toStringAsFixed(6));

      print('🗺️ Conversion geohash $geohash5 → $lat,$lng');
      return LatLng(lat, lng);
    } catch (e) {
      print('❌ Erreur décodage geohash: $e');
      throw EmptyTripGenerationException(
          'Impossible de décoder le geohash $geohash5');
    }
  }
}