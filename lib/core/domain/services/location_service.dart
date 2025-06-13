// core/domain/services/location_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/shared/city_model.dart';
import '../../common/exceptions/exceptions.dart';

/// Service centralisé pour les opérations sur les villes et localisations
class LocationService {
  final SupabaseClient _supabase;

  LocationService(this._supabase);

  /// Vérifie si une ville existe dans la base
  Future<City?> findCity(String cityName) async {
    try {
      final response = await _supabase
          .from('cities')
          .select()
          .eq('city_name', cityName)
          .maybeSingle();
      return response != null ? City.fromJson(response) : null;
    } catch (e) {
      throw DataException('Erreur lors de la recherche de la ville: $e');
    }
  }

  /// Sauvegarde une ville dans la base
  Future<City> saveCity({
    required String cityName,
    required double lat,
    required double lon,
    required String geohash5,
  }) async {
    try {
      final response = await _supabase
          .from('cities')
          .upsert({
        'city_name': cityName,
        'lat': lat,
        'lon': lon,
        'geohash_5': geohash5,
      }, onConflict: 'city_name')
          .select()
          .single();
      return City.fromJson(response);
    } catch (e) {
      throw DataException('Erreur lors de la sauvegarde de la ville: $e');
    }
  }
}