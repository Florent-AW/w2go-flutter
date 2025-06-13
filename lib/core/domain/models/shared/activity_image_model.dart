// core/domain/models/shared/activity_image_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_image_model.freezed.dart';
part 'activity_image_model.g.dart';

@freezed
class ActivityImage with _$ActivityImage {
  const factory ActivityImage({
    String? id,
    String? mobileUrl,
    bool? isMain,
  }) = _ActivityImage;

  factory ActivityImage.fromJson(Map<String, dynamic> json) =>
      _$ActivityImageFromJson(json);
}