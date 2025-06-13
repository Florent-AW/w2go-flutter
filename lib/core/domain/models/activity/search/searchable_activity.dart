// lib/core/domain/models/activity/search/searchable_activity.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../base/activity_base.dart';

part 'searchable_activity.freezed.dart';
part 'searchable_activity.g.dart';

@freezed
class SearchableActivity with _$SearchableActivity {
  const factory SearchableActivity({
    required ActivityBase base,
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
  }) = _SearchableActivity;

  factory SearchableActivity.fromJson(Map<String, dynamic> json) =>
      _$SearchableActivityFromJson(json);

  factory SearchableActivity.fromSupabase(
      Map<String, dynamic> json, {
        double? distanceFromSearch,
      }) {
    final categories = json['categories'] as Map<String, dynamic>?;
    final subcategories = json['activity_subcategories'] as Map<String, dynamic>?;
    final imagesData = json['activities_images'] as List?;
    final mainImageUrl = imagesData?.firstWhere(
          (img) => img['is_main'] == true,
      orElse: () => imagesData.firstOrNull,
    )?['mobile_url'];

    return SearchableActivity(
      base: ActivityBase(
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
        bookingRequired: json['booking_required'] ?? false,
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