// lib/features/categories/application/state/subcategories_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import '../../../../core/domain/models/shared/subcategory_model.dart';
import '../../../../core/domain/ports/providers/search/subcategory_search_provider.dart';
import '../../../search/application/state/section_discovery_providers.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../search/application/state/experience_providers.dart';

/// StateNotifier pour la sous-catégorie actuellement sélectionnée
/// Permet de sélectionner automatiquement la première sous-catégorie
class SelectedSubcategoryNotifier extends StateNotifier<Subcategory?> {
  SelectedSubcategoryNotifier() : super(null);

  void selectFirstForCategory(List<Subcategory> subcategories) {
    if (subcategories.isNotEmpty && state == null) {
      print('🔄 Sélection automatique de la première sous-catégorie: ${subcategories.first.name}');
      state = subcategories.first;
    }
  }

  void selectSubcategory(Subcategory? subcategory) {
    print('🎯 Sélection manuelle de sous-catégorie: ${subcategory?.name ?? "Tous"}');
    state = subcategory;
  }

  void resetSelection() {
    print('🔄 Réinitialisation de la sélection de sous-catégorie');
    state = null;
  }
}

/// Provider pour la sous-catégorie actuellement sélectionnée
/// Valeur null signifie "Tous" (aucun filtre)
final selectedSubCategoryProvider = StateNotifierProvider<SelectedSubcategoryNotifier, Subcategory?>((ref) {
  return SelectedSubcategoryNotifier();
});

/// Provider qui récupère les sous-catégories pour une catégorie donnée
final subCategoriesForCategoryProvider = FutureProvider.family<List<Subcategory>, String>(
        (ref, categoryId) async {
      print('🔍 Chargement des sous-catégories pour la catégorie: $categoryId');
      final subcategorySearchPort = ref.watch(subcategorySearchProvider);

      try {
        // 1. Charger les sous-catégories
        final subcategories = await subcategorySearchPort.getSubcategoriesByCategory(categoryId);
        print('📋 Sous-catégories trouvées: ${subcategories.length}');

        // 2. MODIFICATION: Précharger les sections AVANT de sélectionner une sous-catégorie
        if (subcategories.isNotEmpty) {
          print('🔄 Préchargement des sections...');
          // Attendre explicitement que les sections soient chargées
          final sectionsAsync = ref.read(subcategorySectionsProvider);
          final sections = await sectionsAsync.maybeWhen(
            data: (data) => data,
            orElse: () async {
              // Si les sections ne sont pas disponibles, les charger explicitement
              return await ref.read(subcategorySectionsProvider.future);
            },
          );
          // 3. Maintenant que les sections sont chargées, vérifier s'il faut sélectionner une sous-catégorie
          print('🔄 Tentative de sélection auto...');

          // Vérifier d'abord si une sous-catégorie est déjà sélectionnée pour cette catégorie
          final currentSelection = ref.read(selectedSubcategoryByCategoryProvider(categoryId));
          print('🔍 Sélection actuelle pour catégorie $categoryId: ${currentSelection?.name ?? "null"}');

          // 4. Sélectionner uniquement si aucune sous-catégorie n'est actuellement sélectionnée
          if (currentSelection == null) {
            // IMPORTANT: Utiliser un délai court pour éviter les erreurs pendant le build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              print('🎯 Sélection de la première sous-catégorie: ${subcategories.first.name}');
              // Utiliser le provider par catégorie
              ref.read(selectedSubcategoryByCategoryProvider(categoryId).notifier).state = subcategories.first;
            });
          }
        }

        // Programmation du nettoyage après 60 secondes (TTL)
        final timer = Timer(const Duration(seconds: 60), () {
          // Invalider seulement si le provider est toujours en vie
          try {
            print('⏰ TTL expiré pour les sous-catégories de: $categoryId');
            ref.invalidateSelf();
          } catch (e) {
            print('⚠️ Provider déjà démonté pour: $categoryId');
          }
        });

        // S'assurer que le timer est annulé si le provider est disposé manuellement
        ref.onDispose(() {
          print('🧹 Nettoyage du timer pour les sous-catégories de: $categoryId');
          timer.cancel();
        });

        // Garder en vie pendant l'utilisation active
        ref.keepAlive();

        return subcategories;
      } catch (e) {
        print('❌ Erreur lors du chargement des sous-catégories: $e');
        return [];
      }
    }
);

/// Provider qui indique si l'option "Tous" est sélectionnée
final isAllSubCategoriesSelectedProvider = Provider<bool>((ref) {
  return ref.watch(selectedSubCategoryProvider) == null;
});

// Ajout: Provider pour stocker la sous-catégorie sélectionnée par catégorie
final selectedSubcategoryByCategoryProvider = StateProvider.family<Subcategory?, String>((ref, categoryId) => null);

/// Extension pour les analytics
extension SubCategoryAnalytics on Subcategory? {
  String get analyticsId => this == null ? 'all' : this!.id;
}

/// Provider qui filtre les sous-catégories ayant du contenu
final subcategoriesWithContentProvider = FutureProvider.family<List<Subcategory>, ({String categoryId, City? city})>(
      (ref, params) async {
    final categoryId = params.categoryId;
    final city = params.city;

    if (city == null) return [];

    // 1. Récupérer toutes les sous-catégories
    final allSubcategories = await ref.read(subCategoriesForCategoryProvider(categoryId).future);

    if (allSubcategories.isEmpty) return [];

    // 2. Vérifier lesquelles ont du contenu en parallèle
    final contentChecks = await Future.wait(
      allSubcategories.map((subcategory) async {
        try {
          final experiencesMap = await ref.read(subcategorySectionExperiencesProvider((
          categoryId: categoryId,
          subcategoryId: subcategory.id,
          city: city,
          )).future);

          // Vérifier si au moins une section a du contenu
          final hasContent = experiencesMap.values.any((experiences) => experiences.isNotEmpty);
          return hasContent ? subcategory : null;
        } catch (e) {
          print('❌ Erreur vérification contenu pour ${subcategory.name}: $e');
          return null; // Masquer en cas d'erreur
        }
      }),
    );

    // 3. Filtrer les nulls
    final subcategoriesWithContent = contentChecks
        .where((subcategory) => subcategory != null)
        .cast<Subcategory>()
        .toList();

    print('✅ Sous-catégories avec contenu: ${subcategoriesWithContent.length}/${allSubcategories.length}');
    return subcategoriesWithContent;
  },
);