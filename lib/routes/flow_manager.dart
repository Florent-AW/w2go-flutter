// lib/routes/flow_manager.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/search/application/state/city_selection_state.dart';
import 'route_names.dart';

/// Gère la logique de flux de navigation dans l'application
class FlowManager {
  /// Détermine la route initiale en fonction de si une ville est sélectionnée ou non
  static String getInitialRoute(WidgetRef ref) {
    final selectedCity = ref.read(selectedCityProvider);
    print('🏙️ Ville sélectionnée au démarrage: $selectedCity');
    if (selectedCity == null) {
      print('🔄 Redirection vers: ${RouteNames.welcome}');
      return RouteNames.welcome;
    }
    print('🔄 Redirection vers: ${RouteNames.city}');
    return RouteNames.city;
  }

  /// Vérifie si l'utilisateur peut accéder à une route spécifique
  static bool canAccessRoute(WidgetRef ref, String routeName) {
    final selectedCity = ref.read(selectedCityProvider);

    // Routes qui nécessitent une ville sélectionnée
    final routesRequiringCity = [
      RouteNames.home,
      RouteNames.search,
      RouteNames.category,
      RouteNames.activityDetails,
      RouteNames.tripTest,
      RouteNames.emptyTripsTest,
    ];

    // Si la route nécessite une ville mais qu'aucune n'est sélectionnée
    if (routesRequiringCity.contains(routeName) && selectedCity == null) {
      return false;
    }

    return true;
  }
}