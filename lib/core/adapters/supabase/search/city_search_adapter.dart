// lib/core/adapters/supabase/search/city_search_adapter.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/shared/city_model.dart';
import '../../../domain/ports/search/city_search_port.dart';

class CitySearchAdapter implements CitySearchPort {
  final SupabaseClient _supabase;

  CitySearchAdapter(this._supabase);

  @override
  @override
  Future<List<City>> searchCities(String? query) async {
    try {
      print('DEBUG: Searching cities with query: $query');
      final q = query?.trim() ?? '';
      if (q.isEmpty) return [];

      // Utiliser la fonction RPC au lieu de la requête ilike simple
      final response = await _supabase.rpc(
        'search_cities_prefix',
        params: {'q': q, 'lim': 20},
      );

      if (response == null) {
        print('DEBUG: Cities response is null');
        return [];
      }

      print('DEBUG: Cities found: ${response.length}');
      return (response as List).map<City>((json) => City.fromJson(json)).toList();
    } catch (e) {
      print('DEBUG: Error in searchCities: $e');
      throw e;
    }
  }

  @override
  Future<City?> getCityById(String id) async {
    try {
      final response = await _supabase
          .from('cities')
          .select()
          .eq('id', id)
          .single();

      return response != null ? City.fromJson(response) : null;
    } catch (e) {
      print('Error getting city by id: $e');
      return null;
    }
  }
}