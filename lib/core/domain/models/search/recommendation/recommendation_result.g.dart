// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendationResultImpl _$$RecommendationResultImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendationResultImpl(
      activities: (json['activities'] as List<dynamic>)
          .map((e) => SearchableActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalFound: (json['totalFound'] as num).toInt(),
      sectionType: json['sectionType'] as String,
      sectionTitle: json['sectionTitle'] as String?,
      configLimit: (json['configLimit'] as num?)?.toInt(),
      cacheKey: json['cacheKey'] as String?,
      generatedAt: json['generatedAt'] == null
          ? null
          : DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$RecommendationResultImplToJson(
        _$RecommendationResultImpl instance) =>
    <String, dynamic>{
      'activities': instance.activities,
      'totalFound': instance.totalFound,
      'sectionType': instance.sectionType,
      'sectionTitle': instance.sectionTitle,
      'configLimit': instance.configLimit,
      'cacheKey': instance.cacheKey,
      'generatedAt': instance.generatedAt?.toIso8601String(),
    };
