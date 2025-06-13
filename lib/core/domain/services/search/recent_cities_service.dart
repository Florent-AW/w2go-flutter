// lib/core/domain/services/search/recent_cities_service.dart

import '../../models/search/recent_city.dart';
import '../../models/shared/city_model.dart';
import '../../ports/search/recent_cities_port.dart';

class RecentCitiesService {
  final RecentCitiesPort _recentCitiesPort;
  final int _maxRecentCities;

  RecentCitiesService(this._recentCitiesPort, {int maxRecentCities = 5})
      : _maxRecentCities = maxRecentCities;

  /// Récupère les recherches récentes dans l'ordre chronologique inverse
  Future<List<RecentCity>> getRecentCities() async {
    return _recentCitiesPort.getRecentCities(limit: _maxRecentCities);
  }

  /// Ajoute une ville à l'historique et maintient la taille maximale
  Future<void> addCityToRecent(City city) async {
    final recentCity = RecentCity.now(city);
    await _recentCitiesPort.addRecentCity(recentCity);
  }

  /// Efface l'historique des recherches
  Future<void> clearHistory() async {
    await _recentCitiesPort.clearRecentCities();
  }
}