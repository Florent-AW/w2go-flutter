// lib/features/categories/presentation/widgets/delegates/category_tabs_delegate.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:flutter/rendering.dart'; // RenderAbstractViewport + RevealedOffset


import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../application/state/subcategories_provider.dart';
import '../../constants/ui_constants.dart';
import '../atoms/category_tab.dart';
import 'package:flutter/foundation.dart'; // debugPrint

const bool kTabsSmartLog = true;
void _logTab(String msg) {
  if (!kTabsSmartLog) return;
  debugPrint('[TabsSmart] $msg');
}



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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    // Index sélectionné (catégorie active)
    final int selectedIndex =
    categories.indexWhere((c) => c.id == selectedCategory.id);

    // Auto-align discret après build (idempotent)
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _alignTabsToZone(selectedIndex, animate: false);
    });

    return Container(
      height: tabHeight,
      alignment: Alignment.center,
      color: Colors.transparent,
      child: SingleChildScrollView(
        key: const PageStorageKey('category_tabs_scroll'),
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
                key: tabKeys[i], // clé stable pour ensureVisible
                category: category,
                isActive: isSelected,
                  onTap: () async {
                    HapticFeedback.selectionClick();
                    await _scrollTabsByZones(i); // ⬅️ d'abord on place la barre
                    onCategorySelected(category, i); // ⬅️ puis on notifie
                  }
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> _scrollTabsByZones(int index) async {
    // Attendre que le controller soit attaché
    for (int tries = 0; tries < 20; tries++) {
      if (tabScrollController.hasClients &&
          tabScrollController.position.context.notificationContext != null) {
        break;
      }
      await SchedulerBinding.instance.endOfFrame;
    }
    await _alignTabsToZone(index, animate: true);
  }

  Future<void> _alignTabsToZone(int index, {required bool animate}) async {
    if (!tabScrollController.hasClients) return;
    final pos = tabScrollController.position;
    if (pos.maxScrollExtent <= 0) return; // rien à scroller

    // Zones demandées : 0..2 -> début, 3 -> milieu, 4+ -> fin
    double target;
    if (index <= 2) {
      target = pos.minScrollExtent;
    } else if (index == 3) {
      target = pos.minScrollExtent + (pos.maxScrollExtent - pos.minScrollExtent) / 2;
    } else {
      target = pos.maxScrollExtent;
    }

    // Idempotent : on ne bouge que si nécessaire
    final delta = (target - pos.pixels).abs();
    if (delta <= 2.0) return;

    if (animate) {
      await tabScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    } else {
      tabScrollController.jumpTo(target);
    }
  }

  @override
  bool shouldRebuild(covariant CategoryTabsDelegate oldDelegate) {
    // Optimisation importante: ne reconstruire que si nécessaire
    return oldDelegate.selectedCategory.id != selectedCategory.id ||
        oldDelegate.categories.length != categories.length;
  }


}