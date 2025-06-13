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
  static const String search = '/search';

  // Méthode utilitaire pour générer une route d'activité avec un ID spécifique
  static String getActivityDetailsRoute(String activityId) {
    return '$activityDetails/$activityId';
  }
}