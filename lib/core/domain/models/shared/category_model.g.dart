// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      color: json['color'] as String?,
      coverUrl: json['cover_url'] as String?,
      description: json['description'] as String?,
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'created_at': instance.createdAt?.toIso8601String(),
      'metadata': instance.metadata,
      'color': instance.color,
      'cover_url': instance.coverUrl,
      'description': instance.description,
      'order': instance.order,
    };
