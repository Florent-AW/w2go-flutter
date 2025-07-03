// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SectionMetadataImpl _$$SectionMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$SectionMetadataImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      sectionType: json['section_type'] as String,
      priority: (json['priority'] as num).toInt(),
      categoryId: json['category_id'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt() ?? 999,
      filterConfig: json['filter_config'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SectionMetadataImplToJson(
        _$SectionMetadataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'section_type': instance.sectionType,
      'priority': instance.priority,
      'category_id': instance.categoryId,
      'display_order': instance.displayOrder,
      'filter_config': instance.filterConfig,
    };
