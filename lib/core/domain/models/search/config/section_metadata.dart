// lib/core/domain/models/search/config/section_metadata.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_metadata.freezed.dart';
part 'section_metadata.g.dart';

@freezed
class SectionMetadata with _$SectionMetadata {
  const factory SectionMetadata({
    required String id,
    required String title,
    @JsonKey(name: 'section_type') required String sectionType,
    required int priority,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'display_order') @Default(999) int displayOrder, // ✅ NOUVEAU
    @JsonKey(name: 'filter_config') Map<String, dynamic>? filterConfig, // ✅ NOUVEAU
  }) = _SectionMetadata;

  factory SectionMetadata.fromJson(Map<String, dynamic> json) =>
      _$SectionMetadataFromJson(json);
}