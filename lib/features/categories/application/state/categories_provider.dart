// lib/features/categories/application/state/categories_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/shared/category_model.dart';
import '../../../../core/domain/ports/providers/search/category_search_provider.dart';

/// Provider pour récupérer toutes les catégories
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final categorySearchPort = ref.watch(categorySearchProvider);

  try {
    final categories = await categorySearchPort.getAllCategories();
    return categories;
  } catch (e) {
    // Logger l'erreur (à remplacer par un vrai système de logging plus tard)
    print('Erreur lors du chargement des catégories: $e');
    return [];
  }
});

/// Provider pour la catégorie actuellement sélectionnée
final selectedCategoryProvider = StateProvider<Category?>((ref) => null);

/// Provider qui retourne la première catégorie (pour la navigation initiale)
final firstCategoryProvider = Provider<Category?>((ref) {
  final categoriesAsync = ref.watch(categoriesProvider);

  return categoriesAsync.when(
    data: (categories) => categories.isNotEmpty ? categories.first : null,
    loading: () => null,
    error: (_, __) => null,
  );
});