// lib/core/domain/models/bonus_activities/potential_bonus_activity.dart

import 'package:equatable/equatable.dart';
import 'value_objects/malus_vol_oiseau.dart';

class PotentialBonusActivity extends Equatable {
  final String id;
  final String emptyDailyTripId;
  final String activityId;
  final MalusVolOiseau malusVolOiseau;
  final DateTime tripDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PotentialBonusActivity({
    required this.id,
    required this.emptyDailyTripId,
    required this.activityId,
    required this.malusVolOiseau,
    required this.tripDate,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [
    id,
    emptyDailyTripId,
    activityId,
    malusVolOiseau,
    createdAt,
    updatedAt
  ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'empty_daily_trip_id': emptyDailyTripId,
    'activity_id': activityId,
    'malus_vol_oiseau': malusVolOiseau.minutes,
    'trip_date': tripDate.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory PotentialBonusActivity.fromJson(Map<String, dynamic> json) {
    return PotentialBonusActivity(
      id: json['id'],
      emptyDailyTripId: json['empty_daily_trip_id'],
      activityId: json['activity_id'],
      malusVolOiseau: MalusVolOiseau.fromInt(json['malus_vol_oiseau']),
      tripDate: DateTime.parse(json['trip_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}