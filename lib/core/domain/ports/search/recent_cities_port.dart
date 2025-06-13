// lib/core/domain/ports/search/recent_cities_port.dart

import '../../models/search/recent_city.dart';

/// Interface pour gérer la persistance des recherches récentes de villes
abstract class RecentCitiesPort {
  /// Récupère la liste des recherches récentes, triées par date (la plus récente en premier)
  Future<List<RecentCity>> getRecentCities({int limit = 5});

  /// Ajoute une ville aux recherches récentes
  /// Si la ville existe déjà, son timestamp est mis à jour
  Future<void> addRecentCity(RecentCity recentCity);

  /// Supprime toutes les recherches récentes
  Future<void> clearRecentCities();
}