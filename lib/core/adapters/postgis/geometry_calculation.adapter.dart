// lib/core/adapters/postgis/geometry_calculation.adapter.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/ports/empty_trips/geometry_calculation.port.dart';
import '../../common/utils/maps_toolkit_utils.dart';
import '../../common/constants/geometry_constants.dart';
import '../../common/exceptions/geometry_calculation_exception.dart';

class GeometryCalculationAdapter implements GeometryCalculationPort {
  final SupabaseClient _supabase;

  GeometryCalculationAdapter(this._supabase);

  @override
  Future<double> calculateDistance(LatLng point1, LatLng point2) async {
    try {
      final response = await _supabase
          .rpc('calculate_distance', params: {
        'lat1': point1.latitude,
        'lng1': point1.longitude,
        'lat2': point2.latitude,
        'lng2': point2.longitude,
      });

      return response as double;
    } catch (_) {
      // Fallback to Maps Toolkit si PostGIS échoue
      return MapsToolkitUtils.calculateHaversineDistance(point1, point2);
    }
  }

  @override
  Future<int> calculateMalusMinutes(double distanceMeters, String travelStyle) async {
    try {
      return MapsToolkitUtils.calculateMalusMinutes(distanceMeters, travelStyle);
    } catch (e) {
      throw GeometryCalculationException('Failed to calculate malus minutes: $e');
    }
  }

  @override
  Future<bool> isLocationOnPath(LatLng point, List<LatLng> pathPoints) async {
    try {
      return MapsToolkitUtils.isLocationOnPath(
          point,
          pathPoints,
          toleranceMeters: GeometryConstants.defaultToleranceMeters
      );
    } catch (e) {
      throw GeometryCalculationException('Failed to check location on path: $e');
    }
  }

  @override
  Future<bool> isWithinMaxDetour(LatLng point, LatLng start, LatLng end) async {
    try {
      final directDistance = await calculateDistance(start, end);
      final detourDistance = await calculateDistance(start, point) +
          await calculateDistance(point, end);

      return detourDistance <= (directDistance + (GeometryConstants.maxDetourDistanceKm * 1000));
    } catch (e) {
      throw GeometryCalculationException('Failed to check max detour: $e');
    }
  }
}