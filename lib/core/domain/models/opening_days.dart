// core/domain/models/opening_days.dart

class OpeningDays {
  final Map<String, Map<String, String>> availableDays;
  final Map<String, String>? allDaysHours;  // Nouveau champ pour "all"

  OpeningDays({
    required this.availableDays,
    this.allDaysHours,
  });

  factory OpeningDays.fromActivityHours(Map<String, dynamic> json) {
    // Si nous avons des horaires pour tous les jours
    if (json['day_of_week']['all'] != null) {
      return OpeningDays(
        availableDays: {},
        allDaysHours: Map<String, String>.from(json['day_of_week']['all']),
      );
    }

    // Sinon, on traite les jours spécifiques
    return OpeningDays(
      availableDays: {}, // à remplir avec les jours spécifiques si nécessaire
      allDaysHours: null,
    );
  }

  bool get hasOpenDays => allDaysHours != null || availableDays.isNotEmpty;

  Map<String, String>? getHoursForDay(String date) {
    return allDaysHours ?? availableDays[date];
  }
}