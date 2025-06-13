// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcategory_section_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubcategorySectionConfigImpl _$$SubcategorySectionConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$SubcategorySectionConfigImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      queryFilter: json['queryFilter'] as String,
      subcategoryId: json['subcategoryId'] as String?,
      priority: (json['priority'] as num).toInt(),
      minAppVersion: json['minAppVersion'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$$SubcategorySectionConfigImplToJson(
        _$SubcategorySectionConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'queryFilter': instance.queryFilter,
      'subcategoryId': instance.subcategoryId,
      'priority': instance.priority,
      'minAppVersion': instance.minAppVersion,
      'isDefault': instance.isDefault,
    };
