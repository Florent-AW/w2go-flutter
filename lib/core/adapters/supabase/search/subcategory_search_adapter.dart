// lib/core/adapters/supabase/search/subcategory_search_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/ports/search/subcategory_search_port.dart';
import '../../../domain/models/shared/subcategory_model.dart';

class SubcategorySearchAdapter implements SubcategorySearchPort {
  final SupabaseClient _client;

  SubcategorySearchAdapter(this._client);

  @override
  Future<List<Subcategory>> getSubcategoriesForSearch() async {
    try {
      final response = await _client
          .from('activity_subcategories')
          .select('id, name, category_id, icon')
          .lt('priority', 20)
          .order('priority', ascending: true);

      // Ajouter une vérification et conversion explicite
      final subcategories = (response as List).map((item) {
        // Assurer que tous les champs requis sont convertis en String
        return {
          'id': item['id'].toString(),
          'name': item['name'].toString(),
          'categoryId': item['category_id'].toString(),
          'description': item['description']?.toString(),
          'icon': item['icon']?.toString() ?? 'activity',
        };
      }).map((json) => Subcategory.fromJson(json)).toList();

      return subcategories;
    } catch (e, stack) {
      throw Exception('Failed to fetch subcategories');
    }
  }

  @override
  Future<List<Subcategory>> getSubcategoriesByCategory(String categoryId) async {
    try {
      final response = await _client
          .from('activity_subcategories')
          .select('id, name, category_id, icon')
          .eq('category_id', categoryId)
          .order('priority', ascending: true);

      // Utiliser la même méthode de conversion que dans getSubcategoriesForSearch
      final subcategories = (response as List).map((item) {
        return {
          'id': item['id'].toString(),
          'name': item['name'].toString(),
          'categoryId': item['category_id'].toString(),
          'description': item['description']?.toString(),
          'icon': item['icon']?.toString() ?? 'activity',
        };
      }).map((json) => Subcategory.fromJson(json)).toList();

      return subcategories;
    } catch (e, stack) {
      print('Erreur lors de la récupération des sous-catégories par catégorie: $e');
      throw Exception('Erreur de récupération des sous-catégories: $e');
    }
  }
}