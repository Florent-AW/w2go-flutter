// core/domain/models/processing/activity_processing_model.dart

import '../trip/activity_model.dart';

class ActivityForProcessing extends Activity {
  String? exclusionReason;
  final double totalScore;
  final double subcategoryScore;
  final bool isSuperWow;
  final String? superwowValidityPeriod;
  final Map<String, dynamic>? superwowScoreSnapshot;
  final Map<String, dynamic>? superwowCriteriaMet;

  ActivityForProcessing({
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
    required super.geohash,
    super.geohash5,
    required super.isWow,
    required super.minDurationMinutes,
    required super.maxDurationMinutes,
    required super.momentPreferences,
    required super.intensityLevel,
    required super.categoryId,
    super.subcategoryId,
    super.kidFriendly,
    super.wheelchairAccessible,
    super.metadata,
    required super.ratingAvg,
    required super.ratingCount,
    super.basePrice,
    super.bookingRequired,
    super.weatherPreferences,
    super.activitySubtype,
    super.seasonPrices,
    this.exclusionReason,
    this.totalScore = 0.0,
    this.subcategoryScore = 0.0,
    this.isSuperWow = false,
    this.superwowValidityPeriod,
    this.superwowScoreSnapshot,
    this.superwowCriteriaMet,
  });

  factory ActivityForProcessing.fromJson(Map<String, dynamic> json) {
    return ActivityForProcessing(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      geohash: json['geohash_4'] ?? '',
      geohash5: json['geohash_5'],
      isWow: json['is_wow'] ?? false,
      minDurationMinutes: json['min_duration_minutes'] ?? 60,
      maxDurationMinutes: json['max_duration_minutes'] ?? 60,
      momentPreferences: (json['moment_preferences'] is List)
          ? List<String>.from(json['moment_preferences'])
          : (json['moment_preferences'] is Map)
          ? (json['moment_preferences'] as Map).keys.cast<String>().toList()
          : [],
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
      exclusionReason: json['exclusion_reason'],
      totalScore: (json['total_score'] ?? 0.0).toDouble(),
      subcategoryScore: (json['subcategory_score'] ?? 0.0).toDouble(),
      isSuperWow: json['is_super_wow'] ?? false,
      superwowValidityPeriod: json['superwow_validity_period'],
      superwowScoreSnapshot: json['superwow_score_snapshot'],
      superwowCriteriaMet: json['superwow_criteria_met'],
    );
  }

  factory ActivityForProcessing.fromActivity(Activity activity) {
    return ActivityForProcessing(
      id: activity.id,
      name: activity.name,
      latitude: activity.latitude,
      longitude: activity.longitude,
      geohash: activity.geohash,
      geohash5: activity.geohash5,
      isWow: activity.isWow,
      minDurationMinutes: activity.minDurationMinutes,
      maxDurationMinutes: activity.maxDurationMinutes,
      momentPreferences: activity.momentPreferences,
      intensityLevel: activity.intensityLevel,
      categoryId: activity.categoryId,
      subcategoryId: activity.subcategoryId,
      kidFriendly: activity.kidFriendly,
      wheelchairAccessible: activity.wheelchairAccessible,
      metadata: activity.metadata,
      ratingAvg: activity.ratingAvg,
      ratingCount: activity.ratingCount,
      basePrice: activity.basePrice,
      bookingRequired: activity.bookingRequired,
      weatherPreferences: activity.weatherPreferences,
      activitySubtype: activity.activitySubtype,
      seasonPrices: activity.seasonPrices,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'exclusion_reason': exclusionReason,
      'total_score': totalScore,
      'subcategory_score': subcategoryScore,
      'is_super_wow': isSuperWow,
      'superwow_validity_period': superwowValidityPeriod,
      'superwow_score_snapshot': superwowScoreSnapshot,
      'superwow_criteria_met': superwowCriteriaMet,
    };
  }
}