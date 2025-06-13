// lib/core/domain/models/event/base/event_base.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_base.freezed.dart';
part 'event_base.g.dart';

@freezed
class EventBase with _$EventBase {
  const factory EventBase({
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
    // 🎯 NOUVEAUX CHAMPS SPÉCIFIQUES AUX EVENTS
    required DateTime startDate,
    required DateTime endDate,
    @Default(false) bool bookingRequired,
    @Default(false) bool hasMultipleOccurrences,
    @Default(false) bool isRecurring,
  }) = _EventBase;

  factory EventBase.fromJson(Map<String, dynamic> json) => _$EventBaseFromJson(json);

  // Factory depuis event_model.dart (future)
  factory EventBase.fromEventModel(dynamic event) {
    return EventBase(
      id: event.id,
      name: event.name,
      description: event.description,
      latitude: event.latitude,
      longitude: event.longitude,
      categoryId: event.categoryId,
      subcategoryId: event.subcategoryId,
      city: event.city,
      isWow: event.isWow,
      basePrice: event.basePrice,
      ratingAvg: double.tryParse(event.ratingAvg.toString()) ?? 0.0,
      ratingCount: event.ratingCount,
      kidFriendly: event.kidFriendly ?? false,
      wheelchairAccessible: event.wheelchairAccessible,
      startDate: event.startDate,
      endDate: event.endDate,
      bookingRequired: event.bookingRequired ?? false,
      hasMultipleOccurrences: event.hasMultipleOccurrences ?? false,
      isRecurring: event.isRecurring ?? false,
    );
  }
}