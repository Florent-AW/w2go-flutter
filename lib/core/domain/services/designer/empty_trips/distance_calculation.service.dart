// lib/core/domain/services/designer/empty_trips/distance_calculation.service.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show sin, cos, sqrt, atan2, pi;
import '../../../models/trip_designer/bonus_activities/value_objects/malus_vol_oiseau.dart';
import '../../../ports/empty_trips/geometry_calculation.port.dart';
import '../../../../common/constants/geometry_constants.dart';
import '../../../../common/exceptions/geometry_calculation_exception.dart';

class DistanceCalculationService {
  final GeometryCalculationPort? _geometryPort; // Optional pour compatibilité

  DistanceCalculationService([this._geometryPort]);

  /// Méthodes existantes
  double calculateDistance(
      LatLng point1,
      LatLng point2, {
        double roadFactor = 1.4
      }) {
    const earthRadius = 6371000;

    final lat1 = point1.latitude * pi / 180;
    final lat2 = point2.latitude * pi / 180;
    final dLat = (point2.latitude - point1.latitude) * pi / 180;
    final dLon = (point2.longitude - point1.longitude) * pi / 180;

    final a = sin(dLat/2) * sin(dLat/2) +
        cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2);
    final c = 2 * atan2(sqrt(a), sqrt(1-a));

    return (earthRadius * c) * roadFactor;
  }

  int estimateTravelTime(double distanceMeters, {double averageSpeedKmh = 50}) {
    final speedMeterPerSecond = averageSpeedKmh / 3.6;
    return (distanceMeters / speedMeterPerSecond).round();
  }

  /// Nouvelles méthodes pour bonus activities
  Future<MalusVolOiseau> calculateActivityMalus({
    required LatLng activityLocation,
    required LatLng tripStart,
    required LatLng tripEnd,
    required String travelStyle,
  }) async {
    try {
      if (_geometryPort != null) {
        // Utilisation du port si disponible
        final isWithinDetour = await _geometryPort!.isWithinMaxDetour(
            activityLocation,
            tripStart,
            tripEnd
        );

        if (!isWithinDetour) {
          throw GeometryCalculationException('Activity is outside acceptable detour range');
        }

        final detourDistance = await _calculateDetourDistanceWithPort(
            activityLocation,
            tripStart,
            tripEnd
        );

        final malusMinutes = await _geometryPort!.calculateMalusMinutes(
            detourDistance,
            travelStyle
        );

        return MalusVolOiseau.fromInt(malusMinutes);
      } else {
        // Fallback vers le calcul local si pas de port
        return _calculateMalusLocally(
            activityLocation,
            tripStart,
            tripEnd,
            travelStyle
        );
      }
    } catch (e) {
      throw GeometryCalculationException('Failed to calculate activity malus: $e');
    }
  }

  Future<double> _calculateDetourDistanceWithPort(
      LatLng activityPoint,
      LatLng start,
      LatLng end
      ) async {
    final directDistance = await _geometryPort!.calculateDistance(start, end);
    final detourDistance = await _geometryPort!.calculateDistance(start, activityPoint) +
        await _geometryPort!.calculateDistance(activityPoint, end);

    return detourDistance - directDistance;
  }

  MalusVolOiseau _calculateMalusLocally(
      LatLng activityLocation,
      LatLng tripStart,
      LatLng tripEnd,
      String travelStyle,
      ) {
    final directDistance = calculateDistance(tripStart, tripEnd);
    final detourDistance = calculateDistance(tripStart, activityLocation) +
        calculateDistance(activityLocation, tripEnd);

    if (detourDistance > directDistance + (GeometryConstants.maxDetourDistanceKm * 1000)) {
      throw GeometryCalculationException('Activity is outside acceptable detour range');
    }

    final factor = switch(travelStyle) {
      'relax' => GeometryConstants.relaxedTravelFactor,
      'active' => GeometryConstants.activeTravelFactor,
      _ => GeometryConstants.balancedTravelFactor
    };

    final estimatedMinutes = estimateTravelTime(detourDistance - directDistance) * factor / 60;

    return MalusVolOiseau.fromInt(estimatedMinutes.round().clamp(
        GeometryConstants.minimumMalusMinutes,
        GeometryConstants.maximumMalusMinutes
    ));
  }
}