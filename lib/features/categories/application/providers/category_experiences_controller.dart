import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../../core/domain/models/shared/category_model.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../../search/application/state/experience_providers.dart';
import '../../../categories/application/state/subcategories_provider.dart';
import '../../../search/application/state/section_discovery_providers.dart';
import '../../application/state/categories_provider.dart';

/// Controller pour gérer la complétion des carrousels CategoryPage
class CategoryExperiencesController extends Notifier<void> {

  @override
  void build() {
    // Pas d'état initial nécessaire
  }

  /// Complète un carrousel Featured en rechargeant avec la limite Supabase complète
  Future<void> completeFeaturedCarousel(String categoryId, String sectionId, City city) async {
    try {
      print('🔄 COMPLETION FEATURED: Début pour catégorie $categoryId, section $sectionId');

      // Invalider le provider Featured pour forcer le rechargement
      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
      final isEventsCategory = categoryId == eventsCategoryId;

      if (isEventsCategory) {
        ref.invalidate(featuredEventsBySectionProvider((
        sectionId: sectionId,
        categoryId: categoryId,
        city: city,
        )));
      } else {
        ref.invalidate(featuredActivitiesBySectionProvider((
        sectionId: sectionId,
        categoryId: categoryId,
        city: city,
        )));
      }

      print('✅ COMPLETION FEATURED: Carrousel Featured rechargé');

    } catch (e) {
      print('❌ COMPLETION FEATURED: Erreur $e');
    }
  }

  /// Complète un carrousel de sous-catégorie en rechargeant avec la limite Supabase complète
  Future<void> completeSubcategoryCarousel(String categoryId, String sectionId, City city) async {
    try {
      print('🔄 COMPLETION SUBCATEGORY: Début pour catégorie $categoryId, section $sectionId');

      // Récupérer la sous-catégorie sélectionnée
      final selectedSubcategory = ref.read(selectedSubcategoryByCategoryProvider(categoryId));
      if (selectedSubcategory == null) {
        print('❌ COMPLETION SUBCATEGORY: Pas de sous-catégorie sélectionnée');
        return;
      }

      // Invalider le provider Subcategory pour forcer le rechargement
      ref.invalidate(subcategorySectionExperiencesProvider((
      categoryId: categoryId,
      subcategoryId: selectedSubcategory.id,
      city: city,
      )));

      print('✅ COMPLETION SUBCATEGORY: Carrousel Subcategory rechargé');

    } catch (e) {
      print('❌ COMPLETION SUBCATEGORY: Erreur $e');
    }
  }

  /// Méthode unifiée pour déterminer le type et compléter
  Future<void> completeCarouselForCategory(String categoryId, String sectionId, City city, {bool isFeatured = false}) async {
    if (isFeatured) {
      await completeFeaturedCarousel(categoryId, sectionId, city);
    } else {
      await completeSubcategoryCarousel(categoryId, sectionId, city);
    }
  }
}

/// Provider pour le controller
final categoryExperiencesControllerProvider = NotifierProvider<CategoryExperiencesController, void>(
  CategoryExperiencesController.new,
);