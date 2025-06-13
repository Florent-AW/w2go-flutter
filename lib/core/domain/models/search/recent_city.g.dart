// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecentCityImpl _$$RecentCityImplFromJson(Map<String, dynamic> json) =>
    _$RecentCityImpl(
      city: City.fromJson(json['city'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$RecentCityImplToJson(_$RecentCityImpl instance) =>
    <String, dynamic>{
      'city': instance.city,
      'timestamp': instance.timestamp.toIso8601String(),
    };
