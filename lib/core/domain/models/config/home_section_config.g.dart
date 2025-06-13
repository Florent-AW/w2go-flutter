// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_section_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeSectionConfigImpl _$$HomeSectionConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$HomeSectionConfigImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      queryFilter: const QueryFilterConverter().fromJson(json['queryFilter']),
      iconUrl: json['iconUrl'] as String?,
      priority: (json['priority'] as num).toInt(),
      minAppVersion: json['minAppVersion'] as String,
    );

Map<String, dynamic> _$$HomeSectionConfigImplToJson(
        _$HomeSectionConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'queryFilter': const QueryFilterConverter().toJson(instance.queryFilter),
      'iconUrl': instance.iconUrl,
      'priority': instance.priority,
      'minAppVersion': instance.minAppVersion,
    };
