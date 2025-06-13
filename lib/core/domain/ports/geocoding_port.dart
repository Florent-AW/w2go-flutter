// core/domain/ports/geocoding_port.dart

import '../models/shared/city_model.dart';


abstract class GeocodingPort {
  Future<City> getCity(String cityName);
  Future<List<City>> getMultipleCities(List<String> cityNames);
}