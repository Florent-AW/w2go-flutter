// lib/features/categories/presentation/widgets/delegates/category_cover_with_tabs_delegate.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_in_perigord_app/core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/components/molecules/measured_switcher.dart';
import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../../core/domain/ports/providers/search/category_covers_provider.dart';
import '../../constants/ui_constants.dart';
import './category_cover_delegate.dart';
import './category_tabs_delegate.dart';
import '../../controllers/cover_controller.dart';

class CategoryCoverWithTabsDelegate extends SliverPersistentHeaderDelegate {
  final CoverController controller;
  final List<CategoryViewModel> categories;
  final Function(CategoryViewModel, int) onCategorySelected;
  final ScrollController tabScrollController;
  final BuildContext? contextRef;
  final List<GlobalKey> tabKeys;
  final double _maxExtent;
  final double _tabHeight = CategoryUIConstants.tabHeight;

  CategoryCoverWithTabsDelegate({
    required this.controller,
    required this.categories,
    required this.onCategorySelected,
    required double screenHeight,
    required this.tabScrollController,
    required this.tabKeys,
    this.contextRef,
  }) : _maxExtent = screenHeight * CategoryUIConstants.coverHeight;

  @override
  double get minExtent => _maxExtent;

  @override
  double get maxExtent => _maxExtent;

  @override
  bool shouldRebuild(covariant CategoryCoverWithTabsDelegate oldDelegate) {
    // Ne reconstruire que si les dimensions changent
    return oldDelegate._maxExtent != _maxExtent;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final category = controller.category;
        final previousCategory = controller.previousCategory;
        final isAnimating = controller.isAnimating;

        return Stack(
          children: [
            // Cover en arrière-plan
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: RepaintBoundary(
                  key: ValueKey<String>(category.id),
                  child: CategoryCoverDelegate(
                    category: category,
                    previousCategory: previousCategory,
                    isAnimating: isAnimating,
                    screenHeight: _maxExtent / CategoryUIConstants.coverHeight,
                    contextRef: contextRef,
                  ).build(context, shrinkOffset, overlapsContent),
                ),
              ),
            ),

            // Texte de description
            Positioned(
              left: AppDimensions.space4,
              right: AppDimensions.space16,
              top: _maxExtent * 0.62,
              child: MeasuredSwitcher(
                child: Consumer(
                  builder: (context, ref, _) {
                    final descriptionAsync = ref.watch(
                        categoryDepartmentDescriptionProvider(category)
                    );

                    final textStyle = AppTypography.title(
                        isDark: Theme.of(context).brightness == Brightness.dark
                    ).copyWith(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 6.0,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ],
                    );

                    return descriptionAsync.when(
                      data: (description) {
                        return Text(
                          key: ValueKey<String>("desc_${category.id}_$description"),
                          description,
                          style: textStyle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                      loading: () => Text(
                        key: ValueKey<String>("desc_loading_${category.id}"),
                        category.description ?? "",
                        style: textStyle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      error: (_, __) => Text(
                        key: ValueKey<String>("desc_error_${category.id}"),
                        category.description ?? "",
                        style: textStyle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
            ),            // Tabs
            Positioned(
              left: 0,
              right: 0,
              bottom: -4,
              child: CategoryTabsDelegate(
                categories: categories,
                selectedCategory: category,
                onCategorySelected: onCategorySelected,
                tabScrollController: tabScrollController,
                tabKeys: tabKeys,
              ).build(context, 0, false),
            ),
          ],
        );
      },
    );
  }
}