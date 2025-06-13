// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searchable_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchableEventImpl _$$SearchableEventImplFromJson(
        Map<String, dynamic> json) =>
    _$SearchableEventImpl(
      base: EventBase.fromJson(json['base'] as Map<String, dynamic>),
      categoryName: json['categoryName'] as String?,
      subcategoryName: json['subcategoryName'] as String?,
      subcategoryIcon: json['subcategoryIcon'] as String?,
      geohash4: json['geohash4'] as String?,
      geohash5: json['geohash5'] as String?,
      approxDistanceKm: (json['approxDistanceKm'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      city: json['city'] as String?,
      mainImageUrl: json['mainImageUrl'] as String?,
      momentPreferences: (json['momentPreferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      weatherPreferences: (json['weatherPreferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SearchableEventImplToJson(
        _$SearchableEventImpl instance) =>
    <String, dynamic>{
      'base': instance.base,
      'categoryName': instance.categoryName,
      'subcategoryName': instance.subcategoryName,
      'subcategoryIcon': instance.subcategoryIcon,
      'geohash4': instance.geohash4,
      'geohash5': instance.geohash5,
      'approxDistanceKm': instance.approxDistanceKm,
      'distance': instance.distance,
      'city': instance.city,
      'mainImageUrl': instance.mainImageUrl,
      'momentPreferences': instance.momentPreferences,
      'weatherPreferences': instance.weatherPreferences,
    };
