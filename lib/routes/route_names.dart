// lib/routes/route_names.dart (mise à jour)

/// Centralisation des noms de routes de l'application
///
/// Permet d'éviter les erreurs de frappe et facilite la maintenance
class RouteNames {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String tripTest = '/trip-test';
  static const String emptyTripsTest = '/empty-trips-test';
  static const String category = '/category';
  static const String categoryWithId = '/category/:id';


  // Routes futures (à compléter au fur et à mesure)
  static const String activityDetails = '/activity-details';
  static const String activityDetailsWithId = '/activity-details/:id';
  static const String eventDetails = '/event-details';
  static const String eventDetailsWithId = '/event-details/:id';
  static const String search = '/search';
  static const String termsSearch = '/search/terms';
  static const String termsResults = '/search/terms/results';
  static const String city = '/city';
  static const String cityWithId = '/city/:id';
  static const String favorites = '/favorites';

// Méthode utilitaire pour générer une route de ville avec un ID spécifique
  static String getCityRoute(String cityId) {
    return '$city/$cityId';
  }

  // Méthode utilitaire pour générer une route d'activité avec un ID spécifique
  static String getActivityDetailsRoute(String activityId) {
    return '$activityDetails/$activityId';
  }

  // Méthode utilitaire pour générer une route d'événement avec un ID spécifique
  static String getEventDetailsRoute(String eventId) {
    return '$eventDetails/$eventId';
  }
}