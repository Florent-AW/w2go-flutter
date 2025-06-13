// lib/core/domain/models/trip/daily_trip.dart

import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../common/enums/trip_enums.dart';


class DailyTrip extends Equatable {
  final String id;
  final DailyTripType type;
  final DateTime date;
  final LatLng startPoint;
  final LatLng endPoint;
  final List<String> superWowIds;  // Les IDs des SW inclus
  final Duration totalDuration;     // Durée totale estimée
  final int totalDistance;          // Distance en mètres

  const DailyTrip({
    required this.id,
    required this.type,
    required this.date,
    required this.startPoint,
    required this.endPoint,
    required this.superWowIds,
    required this.totalDuration,
    required this.totalDistance,
  });

  @override
  List<Object?> get props => [
    id, type, date, startPoint, endPoint, superWowIds, totalDuration, totalDistance
  ];

  // Conversion depuis/vers JSON pour Supabase
  factory DailyTrip.fromJson(Map<String, dynamic> json) {
    return DailyTrip(
      id: json['id'],
      type: DailyTripType.values.firstWhere(
              (e) => e.toString() == 'DailyTripType.${json['type']}'
      ),
      date: DateTime.parse(json['date']),
      startPoint: LatLng(json['start_lat'], json['start_lng']),
      endPoint: LatLng(json['end_lat'], json['end_lng']),
      superWowIds: List<String>.from(json['superwow_ids']),
      totalDuration: Duration(seconds: json['total_duration']),
      totalDistance: json['total_distance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'planned_date': date.toIso8601String(),
      'start_lat': startPoint.latitude,
      'start_lng': startPoint.longitude,
      'end_lat': endPoint.latitude,
      'end_lng': endPoint.longitude,
      'superwow_ids': superWowIds,
      'total_duration': totalDuration.inSeconds,
      'total_distance': totalDistance,
    };
  }
}