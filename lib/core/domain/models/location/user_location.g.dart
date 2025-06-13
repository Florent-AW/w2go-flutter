// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserLocationImpl _$$UserLocationImplFromJson(Map<String, dynamic> json) =>
    _$UserLocationImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      isFromGps: json['isFromGps'] as bool? ?? false,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$UserLocationImplToJson(_$UserLocationImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
      'isFromGps': instance.isFromGps,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
