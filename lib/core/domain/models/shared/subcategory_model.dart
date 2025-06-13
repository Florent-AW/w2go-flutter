// lib/core/domain/models/shared/subcategory_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'subcategory_model.freezed.dart';
part 'subcategory_model.g.dart';

@freezed
class Subcategory with _$Subcategory {
  const factory Subcategory({
    required String id,
    required String name,
    required String categoryId,
    String? description,
    String? icon,
  }) = _Subcategory;

  factory Subcategory.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryFromJson(json);
}