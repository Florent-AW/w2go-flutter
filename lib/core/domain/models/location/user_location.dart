// lib/core/domain/models/location/user_location.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_location.freezed.dart';
part 'user_location.g.dart';

@freezed
class UserLocation with _$UserLocation {
  const factory UserLocation({
    required double latitude,
    required double longitude,
    double? accuracy,
    @Default(false) bool isFromGps,
    DateTime? timestamp,
  }) = _UserLocation;

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);
}