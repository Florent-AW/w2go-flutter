// lib/core/domain/ports/empty_trips/geometry_calculation.port.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GeometryCalculationPort {
  Future<double> calculateDistance(LatLng point1, LatLng point2);
  Future<int> calculateMalusMinutes(double distanceMeters, String travelStyle);
  Future<bool> isLocationOnPath(LatLng point, List<LatLng> pathPoints);
  Future<bool> isWithinMaxDetour(LatLng point, LatLng start, LatLng end);
}