// lib/core/domain/services/empty_trips/bonus_activity_generation.service.dart

import 'package:uuid/uuid.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/trip_designer/trip/activity_model.dart';
import '../../../models/trip_designer/trip/trip_model.dart';
import '../../../models/trip_designer/empty_trips/empty_daily_trip.dart';
import '../../../models/trip_designer/bonus_activities/potential_bonus_activity.dart';
import '../../../../common/exceptions/geometry_calculation_exception.dart';
import '../../../ports/empty_trips/geometry_calculation.port.dart';
import 'distance_calculation.service.dart';
import 'available_time_calculation.service.dart';

class BonusActivityGenerationService {
  final GeometryCalculationPort _geometryPort;
  final DistanceCalculationService _distanceService;
  final AvailableTimeCalculationService _availableTimeService;

  BonusActivityGenerationService(
      this._geometryPort,
      this._distanceService,
      this._availableTimeService,
      );

  Future<List<PotentialBonusActivity>> generatePotentialBonusActivities({
    required String emptyTripId,
    required List<Activity> availableActivities,
    required EmptyDailyTrip emptyTrip,
    required Trip trip,
  }) async {
    try {
      final potentialBonusActivities = <PotentialBonusActivity>[];

      for (final activity in availableActivities) {
        if (_isActivitySuperWow(activity.id, emptyTrip)) continue;

        try {
          final malus = await _distanceService.calculateActivityMalus(
            activityLocation: LatLng(
                activity.latitude.toDouble(),
                activity.longitude.toDouble()
            ),
            tripStart: _getLocationFromGeohash(emptyTrip.departureGeohash5),
            tripEnd: _getLocationFromGeohash(emptyTrip.arrivalGeohash5),
            travelStyle: trip.travelStyle?.name ?? 'balanced',
          );

          potentialBonusActivities.add(
              PotentialBonusActivity(
                id: const Uuid().v4(),
                emptyDailyTripId: emptyTripId,
                activityId: activity.id,
                malusVolOiseau: malus,
                tripDate: trip.startDate,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )
          );
        } catch (e) {
          continue;
        }
      }

      return potentialBonusActivities;
    } catch (e) {
      throw GeometryCalculationException(
          'Failed to generate potential bonus activities: $e'
      );
    }
  }

  LatLng _getLocationFromGeohash(String geohash) {
    try {
      final GeoHasher geoHasher = GeoHasher();
      final List<double> coordinates = geoHasher.decode(geohash);
      // GeoHasher retourne [longitude, latitude] donc on inverse pour LatLng
      return LatLng(coordinates[1], coordinates[0]);
    } catch (e) {
      throw GeometryCalculationException('Failed to decode geohash: $e');
    }
  }

  bool _isActivitySuperWow(String activityId, EmptyDailyTrip emptyTrip) {
    return activityId == emptyTrip.sw1Id || activityId == emptyTrip.sw2Id;
  }

  Future<Map<DateTime, int>> calculateAvailableTimeForAllDates({
    required String emptyTripId,
    required Map<String, Map<String, String?>> dailyHours,
    required String travelStyle,
    required List<String> superWowIds,
  }) async {
    final Map<DateTime, int> availableTimeByDate = {};

    for (var entry in dailyHours.entries) {
      final date = DateTime.parse(entry.key);
      final hours = entry.value;

      if (hours['start'] != null && hours['end'] != null) {
        final activityHoursMap = {
          'start': hours['start']!,
          'end': hours['end']!,
        };

        final availableTime = await _availableTimeService.calculateAvailableTime(
          emptyTripId: emptyTripId,
          activityHours: activityHoursMap,
          travelStyle: travelStyle,
          superWowIds: superWowIds,
        );

        availableTimeByDate[date] = availableTime;
      }
    }

    return availableTimeByDate;
  }

}