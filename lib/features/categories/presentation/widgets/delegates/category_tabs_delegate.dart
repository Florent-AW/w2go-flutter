// lib/features/categories/presentation/widgets/delegates/category_tabs_delegate.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../application/state/subcategories_provider.dart';
import '../../constants/ui_constants.dart';
import '../atoms/category_tab.dart';


/// Délégué pour l'affichage de la barre d'onglets de catégories
/// Cette molécule regroupe les atomes CategoryTab dans une barre défilante
class CategoryTabsDelegate extends SliverPersistentHeaderDelegate {
  final List<CategoryViewModel> categories;
  final CategoryViewModel selectedCategory;
  final Function(CategoryViewModel, int) onCategorySelected;
  final ScrollController tabScrollController;
  final double tabHeight;
  final double bottomOverlap;

  // Liste de clés stables, passée du parent
  final List<GlobalKey> tabKeys;

  CategoryTabsDelegate({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.tabScrollController,
    required this.tabKeys,
    this.tabHeight = CategoryUIConstants.tabHeight,
    this.bottomOverlap = CategoryUIConstants.tabOverlap,
  });

  @override
  double get minExtent => tabHeight;

  @override
  double get maxExtent => tabHeight;

// Méthode helper pour précharger une catégorie spécifique
  void _prefetchCategory(BuildContext context, String categoryId) {
    try {
      // Utiliser ProviderScope pour accéder au container
      final container = ProviderScope.containerOf(context);
      // Précharger les sous-catégories sans affecter l'UI
      container.read(subCategoriesForCategoryProvider(categoryId).future);
    } catch (e) {
      print('⚠️ Erreur lors du préchargement de la catégorie $categoryId: $e');
    }
  }

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Container(
      height: tabHeight,
      alignment: Alignment.center,
      color: Colors.transparent,
      // Ajouter un détecteur de geste pour bloquer le swipe horizontal
      child: GestureDetector(
        onHorizontalDragStart: (_) {
          // Fournir un feedback haptique quand l'utilisateur essaie de swiper
          HapticFeedback.lightImpact();
        },
        child: SingleChildScrollView(
          controller: tabScrollController,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: List.generate(categories.length, (i) {
              final category = categories[i];
              final isSelected = category.id == selectedCategory.id;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: CategoryTab(
                  key: tabKeys[i], // Utiliser la clé stable
                  category: category,
                  isActive: isSelected,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    // Passer la catégorie et l'index
                    onCategorySelected(category, i);

                    // Ajouter le préchargement des catégories adjacentes
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Précharger la catégorie précédente si elle existe
                      if (i > 0) {
                        _prefetchCategory(context, categories[i - 1].id);
                      }
                      // Précharger la catégorie suivante si elle existe
                      if (i < categories.length - 1) {
                        _prefetchCategory(context, categories[i + 1].id);
                      }
                    });
                  },
                ),
              );
            }),
          ),
        ),      ),
    );
  }

  @override
  bool shouldRebuild(covariant CategoryTabsDelegate oldDelegate) {
    // Optimisation importante: ne reconstruire que si nécessaire
    return oldDelegate.selectedCategory.id != selectedCategory.id ||
        oldDelegate.categories.length != categories.length;
  }


}