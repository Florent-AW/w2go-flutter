// lib/features/categories/presentation/widgets/delegates/subcategory_tabs_delegate.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/domain/models/shared/subcategory_model.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../atoms/subcategory_tab.dart';

class SubcategoryTabsDelegate extends SliverPersistentHeaderDelegate {
  final List<Subcategory> subcategories;
  final TabController tabController;
  final Function(Subcategory?, int) onSubcategorySelected;
  final Color categoryColor;
  final double height;

  SubcategoryTabsDelegate({
    required this.subcategories,
    required this.tabController,
    required this.onSubcategorySelected,
    required this.categoryColor,
    this.height = 72.0,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return AnimatedBuilder(
      animation: tabController, // ✅ Écoute les changements d'index du TabController
      builder: (context, _) {
        return SizedBox(
          height: height - 1,
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.only(left: AppDimensions.spacingS),
            labelPadding: EdgeInsets.only(right: AppDimensions.spacingS),
            splashFactory: NoSplash.splashFactory, // ✅ Désactiver le ripple du TabBar
            overlayColor: MaterialStateProperty.all(Colors.transparent), // ✅ Ajouter cette ligne
            indicatorSize: TabBarIndicatorSize.label,
            indicator: const BoxDecoration(),
            dividerColor: Colors.transparent,
            labelColor: categoryColor,
            unselectedLabelColor: categoryColor.withOpacity(0.6),
            onTap: (index) {
              HapticFeedback.selectionClick();
              onSubcategorySelected(subcategories[index], index);
            },
            tabs: List.generate(
              subcategories.length,
                  (index) => Tab(
                height: height - 8,
                child: SubcategoryTab(
                  subcategory: subcategories[index],
                  isSelected: tabController.index == index, // ✅ Sera recalculé à chaque changement
                  categoryColor: categoryColor,
                  height: height - 8,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(covariant SubcategoryTabsDelegate oldDelegate) {
    return oldDelegate.categoryColor != categoryColor ||
        oldDelegate.subcategories.length != subcategories.length ||
        oldDelegate.tabController != tabController ||
        oldDelegate.tabController.index != tabController.index; // ✅ AJOUTER cette ligne
  }
}