// lib/core/domain/models/config/subcategory_section_config.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'subcategory_section_config.freezed.dart';
part 'subcategory_section_config.g.dart';

@freezed
class SubcategorySectionConfig with _$SubcategorySectionConfig {
  const factory SubcategorySectionConfig({
    required String id,
    required String title,
    required String queryFilter,
    String? subcategoryId,  // Nullable car peut être null pour config par défaut
    required int priority,
    required String minAppVersion,
    @Default(false) bool isDefault,  // Nouveau champ avec valeur par défaut
  }) = _SubcategorySectionConfig;

  factory SubcategorySectionConfig.fromJson(Map<String, dynamic> json) =>
      _$SubcategorySectionConfigFromJson(json);
}