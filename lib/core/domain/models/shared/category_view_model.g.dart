// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryViewModelImpl _$$CategoryViewModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryViewModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      color: json['color'] as String? ?? '#FFFFFF',
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$$CategoryViewModelImplToJson(
        _$CategoryViewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'color': instance.color,
      'description': instance.description,
      'icon': instance.icon,
    };
