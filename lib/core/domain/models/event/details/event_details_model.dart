// lib/core/domain/models/event/details/event_details_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../base/event_base.dart';
import '../../shared/event_image_model.dart';

part 'event_details_model.freezed.dart';
part 'event_details_model.g.dart';

@freezed
class EventDetails with _$EventDetails {
  const factory EventDetails({
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
    List<EventImage>? images,
    // ✅ CHAMPS SPÉCIFIQUES AUX EVENTS
    required DateTime startDate,
    required DateTime endDate,
    @Default(false) bool bookingRequired,
    @Default(false) bool hasMultipleOccurrences,
    @Default(false) bool isRecurring,
  }) = _EventDetails;

  factory EventDetails.fromJson(Map<String, dynamic> json) =>
      _$EventDetailsFromJson(json);

  factory EventDetails.fromEventBase(EventBase base) {
    return EventDetails(
      id: base.id,
      name: base.name,
      description: base.description,
      latitude: base.latitude,
      longitude: base.longitude,
      categoryId: base.categoryId,
      startDate: base.startDate,
      endDate: base.endDate,
      bookingRequired: base.bookingRequired,
      hasMultipleOccurrences: base.hasMultipleOccurrences,
      isRecurring: base.isRecurring,
    );
  }
}