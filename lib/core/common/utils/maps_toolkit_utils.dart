// lib/core/common/utils/maps_toolkit_utils.dart

import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../exceptions/geometry_calculation_exception.dart';
import '../constants/geometry_constants.dart';

class MapsToolkitUtils {
  static double calculateHaversineDistance(LatLng start, LatLng end) {
    try {
      return mtk.SphericalUtil.computeDistanceBetween(
          mtk.LatLng(start.latitude, start.longitude),
          mtk.LatLng(end.latitude, end.longitude)
      ).toDouble();
    } catch (e) {
      throw GeometryCalculationException('Error calculating haversine distance: $e');
    }
  }

  static bool isLocationOnPath(
      LatLng point,
      List<LatLng> pathPoints,
      {double? toleranceMeters}
      ) {
    try {
      return mtk.PolygonUtil.isLocationOnPath(
          mtk.LatLng(point.latitude, point.longitude),
          pathPoints.map((p) => mtk.LatLng(p.latitude, p.longitude)).toList(),
          true  // On met simplement true car le paramètre est obligatoire mais son utilisation n'est pas claire dans maps_toolkit
      );
    } catch (e) {
      throw GeometryCalculationException('Error checking location on path: $e');
    }
  }

  static int calculateMalusMinutes(
      double distanceMeters,
      String travelStyle,
      ) {
    try {
      final factor = switch(travelStyle) {
        'relax' => GeometryConstants.relaxedTravelFactor,
        'active' => GeometryConstants.activeTravelFactor,
        _ => GeometryConstants.balancedTravelFactor
      };

      final estimatedMinutes = (distanceMeters * factor) /
          (GeometryConstants.averageSpeedMetersPerSecond * 60);

      return estimatedMinutes.clamp(
          GeometryConstants.minimumMalusMinutes.toDouble(),
          GeometryConstants.maximumMalusMinutes.toDouble()
      ).round();
    } catch (e) {
      throw GeometryCalculationException('Error calculating malus minutes: $e');
    }
  }
}