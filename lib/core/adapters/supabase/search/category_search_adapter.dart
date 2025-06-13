// lib/core/adapters/supabase/search/category_search_adapter.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/models/shared/category_model.dart';
import '../../../domain/ports/search/category_search_port.dart';

class CategorySearchAdapter implements CategorySearchPort {
  final SupabaseClient _client;

  CategorySearchAdapter(this._client);

  @override
  Future<List<Category>> getAllCategories() async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .order('order', ascending: true)
          .order('name');

      // Conversion des données brutes en modèles du domaine
      final List<Category> categories = (response as List)
          .map((json) {
        // Nettoyer l'URL de couverture si elle existe
        if (json['cover_url'] != null) {
          json['cover_url'] = json['cover_url'].toString().trim();
        }
        return Category.fromJson(json);
      })
          .toList();

      return categories;
    } catch (e) {
      throw Exception('Erreur lors du chargement des catégories: $e');
    }
  }
}