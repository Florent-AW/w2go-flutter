// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityExperienceImpl _$$ActivityExperienceImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityExperienceImpl(
      SearchableActivity.fromJson(json['activity'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ActivityExperienceImplToJson(
        _$ActivityExperienceImpl instance) =>
    <String, dynamic>{
      'activity': instance.activity,
      'runtimeType': instance.$type,
    };

_$EventExperienceImpl _$$EventExperienceImplFromJson(
        Map<String, dynamic> json) =>
    _$EventExperienceImpl(
      SearchableEvent.fromJson(json['event'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$EventExperienceImplToJson(
        _$EventExperienceImpl instance) =>
    <String, dynamic>{
      'event': instance.event,
      'runtimeType': instance.$type,
    };
