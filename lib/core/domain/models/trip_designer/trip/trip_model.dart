// lib/core/domain/models/trip_model.dart

import '../../shared/city_model.dart';
import '../../../../common/enums/trip_enums.dart';
import 'package:equatable/equatable.dart';

class Trip extends Equatable{
  final String id;
  final String userId;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final double? dailyBudget;
  final String status;
  final Map<String, dynamic> metadata;
  final TravelGroup travelGroup;
  final int tripDuration;
  final ActivityHours activityHours;
  final String? departureCityId;
  final String? departureGeohash5;
  final TravelStyle? travelStyle;
  final PreferredMoment? preferredMoment;
  final int? maxActivitiesPerDay;
  final DateTime createdAt;
  final DateTime updatedAt;
  final City? departureCity;
  final List<ExplorationType> activeExplorationType;

  Trip({
    required this.id,
    required this.userId,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.dailyBudget,
    required this.status,
    required this.metadata,
    required this.travelGroup,
    required this.tripDuration,
    required this.activityHours,
    this.departureCityId,
    this.departureGeohash5,
    this.travelStyle,
    this.preferredMoment,
    this.maxActivitiesPerDay,
    required this.createdAt,
    required this.updatedAt,
    this.departureCity,
    required this.activeExplorationType,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    print('Raw JSON in fromJson: ${json}');

    return Trip(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      dailyBudget: json['daily_budget']?.toDouble(),
      status: json['status'],
      metadata: json['metadata'] ?? {},
      maxActivitiesPerDay: json['max_activities_per_day'],
      travelGroup: TravelGroup.fromJson(json['travel_group'] ?? {}),
      tripDuration: json['trip_duration'],
      activityHours: ActivityHours.fromJson(json['activity_hours'] ?? {}),
      departureCityId: json['departure_city_id'],
      departureGeohash5: json['departure_geohash5'],
      travelStyle: TravelStyleExtension.fromJson(json['travel_style']),
      preferredMoment: PreferredMomentExtension.fromJson(json['preferred_moment']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      departureCity: json['departure_city'] != null
          ? City.fromJson(json['departure_city'])
          : null,
      activeExplorationType: (json['active_exploration_types'] as List)
          .map((type) => ExplorationTypeExtension.fromJson(type) ?? ExplorationType.around_me)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'daily_budget': dailyBudget,
      'status': status,
      'metadata': metadata,
      'max_activities_per_day': maxActivitiesPerDay,
      'travel_group': travelGroup.toJson(),
      'trip_duration': tripDuration,
      'activity_hours': activityHours.toJson(),
      'departure_city_id': departureCityId,
      'departure_geohash5': departureGeohash5,
      'travel_style': travelStyle?.value,
      'preferred_moment': preferredMoment?.value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'active_exploration_types': activeExplorationType.map((e) => e.value).toList(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    startDate,
    endDate,
    dailyBudget,
    status,
    metadata,
    travelGroup,
    tripDuration,
    activityHours,
    departureCityId,
    departureGeohash5,
    travelStyle,
    preferredMoment,
    maxActivitiesPerDay,
    createdAt,
    updatedAt,
    departureCity,
    activeExplorationType,
  ];
}

class ActivityHours {
  final String start;
  final String end;
  final Map<String, Map<String, String?>> daily_hours;

  const ActivityHours({
    required this.start,
    required this.end,
    required this.daily_hours,
  });

  factory ActivityHours.fromJson(Map<String, dynamic> json) {
    print('ActivityHours JSON: $json');
    return ActivityHours(
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      daily_hours: json['daily_hours'] != null
          ? Map<String, Map<String, String?>>.from(
        json['daily_hours'].map((key, value) => MapEntry(
          key,
          Map<String, String?>.from(value as Map),
        )),
      )
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'daily_hours': daily_hours,
    };
  }
}

class TravelGroup {
  final String type;
  final TravelGroupMembers members;
  final String physicalCondition;

  const TravelGroup({
    required this.type,
    required this.members,
    required this.physicalCondition,
  });

  factory TravelGroup.fromJson(Map<String, dynamic> json) {
    return TravelGroup(
      type: json['type'] ?? '',
      members: TravelGroupMembers.fromJson(json['members'] ?? {}),
      physicalCondition: json['physical_condition'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'members': members.toJson(),
      'physical_condition': physicalCondition,
    };
  }
}

class TravelGroupMembers {
  final bool pmr;
  final int adults;
  final bool seniors;
  final List<int> children;
  final List<int> teenagers;

  const TravelGroupMembers({
    required this.pmr,
    required this.adults,
    required this.seniors,
    required this.children,
    required this.teenagers,
  });

  factory TravelGroupMembers.fromJson(Map<String, dynamic> json) {
    return TravelGroupMembers(
      pmr: json['pmr'] ?? false,
      adults: json['adults'] ?? 0,
      seniors: json['seniors'] ?? false,
      children: json['children'] != null
          ? List<int>.from(json['children'])
          : [],
      teenagers: json['teenagers'] != null
          ? List<int>.from(json['teenagers'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pmr': pmr,
      'adults': adults,
      'seniors': seniors,
      'children': children,
      'teenagers': teenagers,
    };
  }
}