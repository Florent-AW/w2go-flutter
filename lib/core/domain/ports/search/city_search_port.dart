// lib/core/domain/ports/search/city_search_port.dart

import '../../models/shared/city_model.dart';


abstract class CitySearchPort {
  Future<List<City>> searchCities(String? query);
  Future<City?> getCityById(String id);
}