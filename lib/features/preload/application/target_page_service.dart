import 'package:flutter/material.dart';

class TargetPageService {
  /// Détermine le type de page où naviguer selon la route actuelle
  static String determineTargetPageType(BuildContext context) {
    // ✅ SOLUTION SIMPLE: Utiliser ModalRoute
    final routeName = ModalRoute.of(context)?.settings.name;

    print('🔍 ROUTE DETECTION: Route name: $routeName');

    if (routeName?.contains('city') == true) {
      return 'city';
    }

    if (routeName?.contains('category') == true) {
      return 'category';
    }

    // Fallback depuis Welcome ou autres
    return 'city';
  }
}