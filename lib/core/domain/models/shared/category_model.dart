// lib/core/domain/models/shared/category_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? icon,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    Map<String, dynamic>? metadata,
    String? color,
    @JsonKey(name: 'cover_url') String? coverUrl,
    String? description,
    int? order,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}