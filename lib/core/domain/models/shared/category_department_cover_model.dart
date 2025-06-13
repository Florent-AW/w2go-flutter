// lib/core/domain/models/shared/category_department_cover_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_department_cover_model.freezed.dart';
part 'category_department_cover_model.g.dart';

@freezed
class CategoryDepartmentCover with _$CategoryDepartmentCover {
  const factory CategoryDepartmentCover({
    required String id,
    required String categoryId,
    required String departmentCode,
    required String departmentName,
    required String coverUrl,
    String? description, // Nouveau champ pour la description
    @Default(10) int priority,
  }) = _CategoryDepartmentCover;

  factory CategoryDepartmentCover.fromJson(Map<String, dynamic> json) =>
      _$CategoryDepartmentCoverFromJson(json);
}