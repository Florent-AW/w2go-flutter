// lib/core/domain/models/event/search/searchable_event.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../base/event_base.dart';

part 'searchable_event.freezed.dart';
part 'searchable_event.g.dart';

@freezed
class SearchableEvent with _$SearchableEvent {
  const factory SearchableEvent({
    required EventBase base,
    String? categoryName,
    String? subcategoryName,
    String? subcategoryIcon,
    String? geohash4,
    String? geohash5,
    double? approxDistanceKm,
    double? distance,
    String? city,
    String? mainImageUrl,
    List<String>? momentPreferences,
    List<String>? weatherPreferences,
  }) = _SearchableEvent;

  factory SearchableEvent.fromJson(Map<String, dynamic> json) =>
      _$SearchableEventFromJson(json);

  factory SearchableEvent.fromSupabase(
      Map<String, dynamic> json, {
        double? distanceFromSearch,
      }) {
    final categories = json['categories'] as Map<String, dynamic>?;
    final subcategories = json['activity_subcategories'] as Map<String, dynamic>?;
    final imagesData = json['events_images'] as List?; // Note: events_images au lieu de activities_images
    final mainImageUrl = imagesData?.firstWhere(
          (img) => img['is_main'] == true,
      orElse: () => imagesData.firstOrNull,
    )?['mobile_url'];

    return SearchableEvent(
      base: EventBase(
        id: json['id'],
        name: json['name'],
        city: json['city'],
        description: json['description'],
        latitude: json['latitude']?.toDouble() ?? 0.0,
        longitude: json['longitude']?.toDouble() ?? 0.0,
        categoryId: json['category_id'] ?? '',
        subcategoryId: json['subcategory_id'],
        isWow: json['is_wow'] ?? false,
        basePrice: json['base_price']?.toDouble(),
        ratingAvg: json['rating_avg']?.toDouble() ?? 0.0,
        ratingCount: json['rating_count'] ?? 0,
        kidFriendly: json['kid_friendly'] ?? false,
        wheelchairAccessible: json['wheelchair_accessible'],
        // 🎯 PARSING DES CHAMPS SPÉCIFIQUES AUX EVENTS
        startDate: DateTime.parse(json['start_date']),
        endDate: DateTime.parse(json['end_date']),
        bookingRequired: json['booking_required'] ?? false,
        hasMultipleOccurrences: json['has_multiple_occurrences'] ?? false,
        isRecurring: json['is_recurring'] ?? false,
      ),
      categoryName: categories?['name'],
      subcategoryName: subcategories?['name'],
      subcategoryIcon: subcategories?['icon'],
      geohash4: json['geohash_4'],
      geohash5: json['geohash_5'],
      approxDistanceKm: (json['approx_distance_km'] as num?)?.toDouble(),
      distance: distanceFromSearch,
      city: json['address']?.toString().split(',').last.trim(),
      mainImageUrl: mainImageUrl,
      momentPreferences: (json['moment_preferences'] as List<dynamic>?)?.cast<String>(),
      weatherPreferences: (json['weather_preferences'] as List<dynamic>?)?.cast<String>(),
    );
  }
}