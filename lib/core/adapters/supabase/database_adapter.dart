// lib\core\adapters\supabase\database_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  // Initialisation de Supabase
  static Future<void> initialize() async {
    await dotenv.load();
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  }

  // Accès au client Supabase
  static SupabaseClient get client => Supabase.instance.client;

  // Récupérer toutes les catégories
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await client
        .from('categories')
        .select()
        .order('name');
    return List<Map<String, dynamic>>.from(response);
  }

  // Récupérer les activités par catégorie
  static Future<List<Map<String, dynamic>>> getActivitiesByCategory(String categoryId) async {
    final response = await client
        .from('activities')
        .select()
        .eq('category_id', categoryId)
        .order('name');
    return List<Map<String, dynamic>>.from(response);
  }

  // Créer un nouveau voyage
  static Future<Map<String, dynamic>> createTrip(Map<String, dynamic> tripData) async {
    final response = await client
        .from('trips')
        .insert(tripData)
        .select()
        .single();
    return response;
  }

  // Récupérer les préférences d'un utilisateur
  static Future<List<Map<String, dynamic>>> getUserPreferences(String userId) async {
    final response = await client
        .from('user_preferences')
        .select('*, categories(*)')
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  // Récupérer les activités filtrées via les préférences utilisateur (RPC)
  static Future<List<Map<String, dynamic>>> getFilteredActivitiesByPreferences(String userId) async {
    try {
      final response = await client.rpc(
        'filter_activities_by_preferences',
        params: {'user_uuid': userId},
      );

      if (response == null) {
        return [];
      }

      // Vérifie si la réponse est une liste
      if (response is! List) {
        throw Exception('Format de réponse invalide');
      }

      // Conversion sécurisée de la réponse
      return response.map((item) {
        if (item is! Map<String, dynamic>) {
          // Conversion explicite si nécessaire
          return Map<String, dynamic>.from(item as Map);
        }
        return item;
      }).toList();

    } catch (e) {
      print('Erreur lors de la récupération des activités filtrées: $e'); // Pour le débogage
      throw Exception('Erreur lors de la récupération des activités : $e');
    }
  }

}