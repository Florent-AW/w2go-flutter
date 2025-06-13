// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_department_cover_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryDepartmentCoverImpl _$$CategoryDepartmentCoverImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryDepartmentCoverImpl(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      departmentCode: json['departmentCode'] as String,
      departmentName: json['departmentName'] as String,
      coverUrl: json['coverUrl'] as String,
      description: json['description'] as String?,
      priority: (json['priority'] as num?)?.toInt() ?? 10,
    );

Map<String, dynamic> _$$CategoryDepartmentCoverImplToJson(
        _$CategoryDepartmentCoverImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'departmentCode': instance.departmentCode,
      'departmentName': instance.departmentName,
      'coverUrl': instance.coverUrl,
      'description': instance.description,
      'priority': instance.priority,
    };
