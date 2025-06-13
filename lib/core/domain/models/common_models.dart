// lib\core\domain\models\common_models.dart

import '../../common/enums/trip_enums.dart';

class GeoPoint {
  final double latitude;
  final double longitude;

  GeoPoint({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}

class GroupMember {
  final GroupMemberType type;
  final bool hasMobilityIssues;

  GroupMember({
    required this.type,
    this.hasMobilityIssues = false,
  });

  Map<String, dynamic> toJson() => {
    'type': type.toString(),
    'hasMobilityIssues': hasMobilityIssues,
  };
}