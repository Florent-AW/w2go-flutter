// lib\core\common\enums\trip_enums.dart

enum GroupMemberType {
  adult,
  senior,
  teenager,
  child,
}

extension GroupMemberTypeExtension on GroupMemberType {
  static GroupMemberType? fromJson(dynamic value) {
    if (value == null) return null;
    return GroupMemberType.values.firstWhere(
          (e) => e.toString().split('.').last == value.toString().toLowerCase(),
      orElse: () => GroupMemberType.adult,
    );
  }

  String get value => toString().split('.').last;
}

enum PreferredMoment {
  morning,
  afternoon,
  all_day,
  evening,
}

extension PreferredMomentExtension on PreferredMoment {
  static PreferredMoment? fromJson(dynamic value) {
    if (value == null) return null;
    switch (value.toString().toLowerCase()) {
      case 'morning':
        return PreferredMoment.morning;
      case 'afternoon':
        return PreferredMoment.afternoon;
      case 'all_day':
        return PreferredMoment.all_day;
      case 'evening':
        return PreferredMoment.evening;
      default:
        throw Exception('Invalid PreferredMoment value: $value');
    }
  }

  String get value {
    return this.toString().split('.').last;
  }
}

enum TravelStyle {
  relax,
  balanced,
  active,
}

extension TravelStyleExtension on TravelStyle {
  static TravelStyle? fromJson(dynamic value) {
    if (value == null) return null;
    switch (value.toString().toLowerCase()) {
      case 'relax':
        return TravelStyle.relax;
      case 'balanced':
        return TravelStyle.balanced;
      case 'active':
        return TravelStyle.active;
      default:
        throw Exception('Invalid TravelStyle value: $value');
    }
  }

  String get value {
    return toString().split('.').last;
  }

  String get displayName {
    return toString().split('.').last;
  }

  int get maxActivities {
    switch (this) {
      case TravelStyle.relax:
        return 4;
      case TravelStyle.balanced:
        return 5;
      case TravelStyle.active:
        return 6;
    }
  }

  int getDurationMinutes(int minDuration, int maxDuration) {
    switch (this) {
      case TravelStyle.relax:
        return maxDuration;
      case TravelStyle.active:
        return minDuration;
      case TravelStyle.balanced:
        return (minDuration + maxDuration) ~/ 2;
      default:
        return minDuration; // Par sécurité, même si tous les cas sont couverts
    }
  }
}

enum ExplorationType {
  around_me,
  small_getaway,
  exploration_day,
  big_adventure
}

extension ExplorationTypeExtension on ExplorationType {

  double get maxDistance {
    switch (this) {
      case ExplorationType.around_me:
        return 35.0;
      case ExplorationType.small_getaway:
        return 56.0;
      case ExplorationType.exploration_day:
        return 90.0;
      case ExplorationType.big_adventure:
        return 120.0;
    }
  }

  static ExplorationType? fromJson(String? json) {
    if (json == null) return null;
    return ExplorationType.values.firstWhere(
          (e) => e.toString().split('.').last == json,
      orElse: () => ExplorationType.around_me,
    );
  }

  String get value => toString().split('.').last;

  // Ajout des limites de temps en minutes
  (int, int) get timeLimits {
    switch (this) {
      case ExplorationType.around_me:
        return (0, 60);  // max 1h
      case ExplorationType.small_getaway:
        return (0, 105);  // max 1h45
      case ExplorationType.exploration_day:
        return (90, 150);  // 1h30 - 2h30
      case ExplorationType.big_adventure:
        return (120, 300);  // 2h - 5h
    }
  }

  static (int, int) getCombinedTimeLimits(List<ExplorationType> types) {
    int minTime = 300;  // Valeur max possible
    int maxTime = 0;    // Valeur min possible

    for (var type in types) {
      final (typeMin, typeMax) = type.timeLimits;
      if (typeMin < minTime) minTime = typeMin;
      if (typeMax > maxTime) maxTime = typeMax;
    }

    return (minTime, maxTime);
  }

  bool isValidDuration(int durationMinutes) {
    final (minMinutes, maxMinutes) = timeLimits;
    return durationMinutes >= minMinutes && durationMinutes <= maxMinutes;
  }

  int getMaxActivitiesByTime(int timeAvailable) {
    if (timeAvailable < 120) return 5;        // < 2h
    if (timeAvailable < 240) return 7;        // 2-4h
    if (timeAvailable < 360) return 8;        // 4-6h
    if (timeAvailable < 480) return 9;        // 6-8h
    return 10;                                // > 8h
  }
}

enum DailyTripType {
  half_day,
  full_day
}
