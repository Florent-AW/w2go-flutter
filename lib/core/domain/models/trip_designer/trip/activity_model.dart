// core\domain\models\trip_designer\trip\activity_model.dart

import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String geohash;
  final String? geohash5;
  final bool isWow;
  final int minDurationMinutes;
  final int maxDurationMinutes;
  final List<String> momentPreferences;
  final int intensityLevel;
  final String categoryId;
  final String? subcategoryId;
  final bool? kidFriendly;
  final String? wheelchairAccessible;
  final Map<String, dynamic>? metadata;
  final String ratingAvg;
  final int ratingCount;
  final double? basePrice;
  final bool? bookingRequired;
  final Map<String, dynamic>? weatherPreferences;
  final String? activitySubtype;
  final Map<String, dynamic>? seasonPrices;

  const Activity({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.geohash,
    this.geohash5,
    required this.isWow,
    required this.minDurationMinutes,
    required this.maxDurationMinutes,
    required this.momentPreferences,
    required this.intensityLevel,
    required this.categoryId,
    this.subcategoryId,
    this.kidFriendly,
    this.wheelchairAccessible,
    this.metadata,
    required this.ratingAvg,
    required this.ratingCount,
    this.basePrice,
    this.bookingRequired,
    this.weatherPreferences,
    this.activitySubtype,
    this.seasonPrices,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    List<String> momentPrefs;
    if (json['moment_preferences'] is List) {
      momentPrefs = List<String>.from(json['moment_preferences']);
    } else if (json['moment_preferences'] is Map) {
      momentPrefs = (json['moment_preferences'] as Map).keys.cast<String>().toList();
    } else {
      momentPrefs = [];
    }

    return Activity(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      geohash: json['geohash_4'] ?? '',
      geohash5: json['geohash_5'],
      isWow: json['is_wow'] ?? false,
      minDurationMinutes: json['min_duration_minutes'] ?? 60,
      maxDurationMinutes: json['max_duration_minutes'] ?? 60,
      momentPreferences: momentPrefs,
      intensityLevel: json['intensity_level'] ?? 1,
      categoryId: json['category_id'] ?? '',
      subcategoryId: json['subcategory_id'],
      kidFriendly: json['kid_friendly'],
      wheelchairAccessible: json['wheelchair_accessible'],
      metadata: json['metadata'],
      ratingAvg: json['rating_avg']?.toString() ?? '0',
      ratingCount: json['rating_count'] ?? 0,
      basePrice: json['base_price']?.toDouble(),
      bookingRequired: json['booking_required'],
      weatherPreferences: json['weather_preferences'],
      activitySubtype: json['activity_subtype'],
      seasonPrices: json['season_prices'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'geohash_4': geohash,
    'geohash_5': geohash5,
    'is_wow': isWow,
    'min_duration_minutes': minDurationMinutes,
    'max_duration_minutes': maxDurationMinutes,
    'moment_preferences': momentPreferences,
    'intensity_level': intensityLevel,
    'category_id': categoryId,
    'subcategory_id': subcategoryId,
    'kid_friendly': kidFriendly,
    'wheelchair_accessible': wheelchairAccessible,
    'metadata': metadata,
    'rating_avg': ratingAvg,
    'rating_count': ratingCount,
    'base_price': basePrice,
    'booking_required': bookingRequired,
    'weather_preferences': weatherPreferences,
    'activity_subtype': activitySubtype,
    'season_prices': seasonPrices,
  };

  // Getters utilitaires
  int get durationMinutes => maxDurationMinutes;
  double get rating => double.tryParse(ratingAvg) ?? 0.0;

  @override
  List<Object?> get props => [
    id,
    name,
    latitude,
    longitude,
    geohash,
    geohash5,
    isWow,
    minDurationMinutes,
    maxDurationMinutes,
    momentPreferences,
    intensityLevel,
    categoryId,
    subcategoryId,
    kidFriendly,
    wheelchairAccessible,
    metadata,
    ratingAvg,
    ratingCount,
    basePrice,
    bookingRequired,
    weatherPreferences,
    activitySubtype,
    seasonPrices,
  ];
}