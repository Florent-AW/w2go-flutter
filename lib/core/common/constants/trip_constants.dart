// core/common/constants/trip_constants.dart


class TripConstants {
  static const Map<String, int> maxTravelTimes = {
    'around_me': 60,      // 1h
    'small_getaway': 105, // 1h45
    'exploration_day': 150, // 2h30
    'big_adventure': 300,  // 5h
  };

  static const Map<String, int> minTravelTimes = {
    'exploration_day': 90,  // 1h30
    'big_adventure': 120,   // 2h
  };

  // Temps de repas standards
  static const int mealDuration = 90; // 1h30 par repas

  // Créneaux de repas
  static const Map<String, (int, int)> mealTimeSlots = {
    'lunch': (12, 13),  // 12h-13h
    'dinner': (19, 20), // 19h-20h
  };

  // Ajouter dans la classe TripConstants
  static const Map<String, int> mealDurationByStyle = {
    'relax': 120,     // 2h par repas
    'balanced': 90,   // 1h30 (standard)
    'active': 60,     // 1h par repas
  };

}