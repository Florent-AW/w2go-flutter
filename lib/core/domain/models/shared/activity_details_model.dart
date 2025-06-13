// core/domain/models/shared/activity_details_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../activity/base/activity_base.dart';
import 'activity_image_model.dart';

part 'activity_details_model.freezed.dart';
part 'activity_details_model.g.dart';

@freezed
class ActivityDetails with _$ActivityDetails {
  const factory ActivityDetails({
    required String id,
    required String name,
    String? description,
    required double latitude,
    required double longitude,
    required String categoryId,
    String? categoryName,
    String? subcategoryName,
    String? subcategoryIcon,
    String? postalCode,
    String? address,
    String? city,
    String? googlePlaceId,
    Map<String, dynamic>? currentOpeningHours,
    String? contactPhone,
    String? contactEmail,
    String? contactWebsite,
    String? bookingLevel,
    bool? kidFriendly,
    String? wheelchairAccessible,
    int? minDurationMinutes,
    int? maxDurationMinutes,
    int? priceLevel,
    double? basePrice,
    List<ActivityImage>? images,
  }) = _ActivityDetails;

  factory ActivityDetails.fromJson(Map<String, dynamic> json) =>
      _$ActivityDetailsFromJson(json);

  factory ActivityDetails.fromActivityBase(ActivityBase base) {
    return ActivityDetails(
      id: base.id,
      name: base.name,
      description: base.description,
      latitude: base.latitude,
      longitude: base.longitude,
      categoryId: base.categoryId,
    );
  }
}