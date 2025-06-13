// lib/core/domain/ports/search/subcategory_search_port.dart

import '../../models/shared/subcategory_model.dart';

abstract class SubcategorySearchPort {
  Future<List<Subcategory>> getSubcategoriesForSearch();

  // Nouvelle méthode optimisée pour récupérer les sous-catégories par catégorie
  Future<List<Subcategory>> getSubcategoriesByCategory(String categoryId);
}