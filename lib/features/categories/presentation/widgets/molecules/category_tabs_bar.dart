// lib/features/categories/presentation/widgets/molecules/category_tabs_bar.dart
// Réintégrer comme molecule

import 'package:flutter/material.dart';
import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../atoms/category_tab.dart';

class CategoryTabsBar extends StatelessWidget {
  final List<CategoryViewModel> categories;
  final CategoryViewModel selectedCategory;
  final Function(CategoryViewModel) onCategorySelected;
  final TabController tabController;

  const CategoryTabsBar({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63,
      // Supprimer toute décoration qui pourrait ajouter une bordure
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        indicator: const BoxDecoration(), // Pas d'indicateur par défaut
        // Supprimer toute ligne de séparation du TabBar
        dividerColor: Colors.transparent,

        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        // Supprimer les bordures inférieures
        indicatorSize: TabBarIndicatorSize.label,
        tabs: categories.map((category) {
          return Tab(
            height: 63, // Aligner avec la hauteur du conteneur parent
            child: CategoryTab(
              category: category,
              isActive: category.id == selectedCategory.id,
              onTap: () {
                final index = categories.indexOf(category);
                tabController.animateTo(index);
                onCategorySelected(category);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}