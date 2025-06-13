// lib/core/domain/empty_trips/empty_daily_trip.dart

import 'package:equatable/equatable.dart';
import '../../../../common/enums/trip_enums.dart';

class EmptyDailyTrip extends Equatable {
  final String id;
  final DailyTripType type;
  final String departureGeohash5;
  final String arrivalGeohash5;
  final String sw1Id;
  final String? sw2Id;
  final List<String> traversedGeohashes;
  final String routePolyline;
  final int totalDuration;
  final int totalDistance;
  final DateTime createdAt;

  const EmptyDailyTrip({
    required this.id,
    required this.type,
    required this.departureGeohash5,
    required this.arrivalGeohash5,
    required this.sw1Id,
    this.sw2Id,
    required this.traversedGeohashes,
    required this.routePolyline,
    required this.totalDuration,
    required this.totalDistance,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    departureGeohash5,
    arrivalGeohash5,
    sw1Id,
    sw2Id,
    traversedGeohashes,
    routePolyline,
    totalDuration,
    totalDistance,
    createdAt,
  ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString().split('.').last,
    'departure_geohash5': departureGeohash5,
    'arrival_geohash5': arrivalGeohash5,
    'sw1_id': sw1Id,
    'sw2_id': sw2Id,
    'traversed_geohashes': traversedGeohashes,
    'route_polyline': routePolyline,
    'total_duration': totalDuration,
    'total_distance': totalDistance,
    'created_at': createdAt.toIso8601String(),
  };
}