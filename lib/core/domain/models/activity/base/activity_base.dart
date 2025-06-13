// lib/core/domain/models/activity/base/activity_base.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_base.freezed.dart';
part 'activity_base.g.dart';

@freezed
class ActivityBase with _$ActivityBase {
  const factory ActivityBase({
    required String id,
    required String name,
    required String? description,
    required double latitude,
    required double longitude,
    required String categoryId,
    String? subcategoryId,
    String? city,
    String? imageUrl,
    @Default(false) bool isWow,
    double? basePrice,
    @Default(0.0) double ratingAvg,
    @Default(0) int ratingCount,
    @Default(false) bool kidFriendly,
    String? wheelchairAccessible,
    @Default(false) bool bookingRequired,
  }) = _ActivityBase;

  factory ActivityBase.fromJson(Map<String, dynamic> json) => _$ActivityBaseFromJson(json);

  // Factory depuis activity_model.dart
  factory ActivityBase.fromActivityModel(dynamic activity) {
    return ActivityBase(
      id: activity.id,
      name: activity.name,
      description: activity.description,
      latitude: activity.latitude,
      longitude: activity.longitude,
      categoryId: activity.categoryId,
      subcategoryId: activity.subcategoryId,
      isWow: activity.isWow,
      basePrice: activity.basePrice,
      ratingAvg: double.tryParse(activity.ratingAvg.toString()) ?? 0.0,
      ratingCount: activity.ratingCount,
      kidFriendly: activity.kidFriendly ?? false,
      wheelchairAccessible: activity.wheelchairAccessible,
      bookingRequired: activity.bookingRequired ?? false,
    );
  }
}