// lib/core/domain/ports/empty_trips/route_optimization.port.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/trip_designer/trip/trip_model.dart';

abstract class RouteOptimizationPort {
  /// Calcule le trajet optimal entre plusieurs points
  Future<Map<String, dynamic>> getOptimizedRoute(
      LatLng origin,
      LatLng destination,
      List<LatLng> waypoints,
      );

  /// Obtient le temps de trajet estimé entre deux points
  Future<Duration> getTravelTime(
      LatLng origin,
      LatLng destination,
      {DateTime? departureTime}
      );

  /// Vérifie si un détour par un point est viable
  Future<Map<String, dynamic>> evaluateDetour(
      LatLng origin,
      LatLng destination,
      LatLng detourPoint,
      Duration maxDetourTime,
      );
}