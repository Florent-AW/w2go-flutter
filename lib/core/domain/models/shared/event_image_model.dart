// lib/core/domain/models/shared/event_image_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_image_model.freezed.dart';
part 'event_image_model.g.dart';

@freezed
class EventImage with _$EventImage {
  const factory EventImage({
    required String id,
    String? mobileUrl,
    @Default(false) bool isMain,
  }) = _EventImage;

  factory EventImage.fromJson(Map<String, dynamic> json) => _$EventImageFromJson(json);
}