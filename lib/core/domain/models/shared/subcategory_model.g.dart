// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcategory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubcategoryImpl _$$SubcategoryImplFromJson(Map<String, dynamic> json) =>
    _$SubcategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$$SubcategoryImplToJson(_$SubcategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categoryId': instance.categoryId,
      'description': instance.description,
      'icon': instance.icon,
    };
