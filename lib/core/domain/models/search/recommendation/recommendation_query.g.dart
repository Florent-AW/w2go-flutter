// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationQueryImpl _$$RecommendationQueryImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationQueryImpl(
      sectionType: json['sectionType'] as String,
      limit: (json['limit'] as num?)?.toInt(),
      excludeCurrentActivity: json['excludeCurrentActivity'] as bool?,
      orderBy: json['orderBy'] as String?,
      orderDirection: json['orderDirection'] as String?,
      maxDistanceKm: (json['maxDistanceKm'] as num?)?.toDouble(),
      sameSubcategory: json['sameSubcategory'] as bool?,
      minRating: (json['minRating'] as num?)?.toDouble(),
      rotation: json['rotation'] as String?,
      randomSample: json['randomSample'] as bool?,
    );

Map<String, dynamic> _$$RecommendationQueryImplToJson(
        _$RecommendationQueryImpl instance) =>
    <String, dynamic>{
      'sectionType': instance.sectionType,
      'limit': instance.limit,
      'excludeCurrentActivity': instance.excludeCurrentActivity,
      'orderBy': instance.orderBy,
      'orderDirection': instance.orderDirection,
      'maxDistanceKm': instance.maxDistanceKm,
      'sameSubcategory': instance.sameSubcategory,
      'minRating': instance.minRating,
      'rotation': instance.rotation,
      'randomSample': instance.randomSample,
    };
