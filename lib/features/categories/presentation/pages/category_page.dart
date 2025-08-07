// lib/features/categories/presentation/pages/category_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../../core/domain/models/shared/category_model.dart';
import '../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../experience_detail/presentation/pages/experience_detail_page.dart';
import '../../../preload/application/preload_providers.dart';
import '../../../preload/application/preload_controller.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../application/state/categories_provider.dart';
import '../widgets/templates/category_page_template.dart';


class CategoryPage extends ConsumerWidget {
  final String? categoryId;

  const CategoryPage({
    Key? key,
    this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 👀 Regarder la ville pour déclencher un rebuild complet à chaque changement
    final city = ref.watch(selectedCityProvider);

    // Récupérer les catégories
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('Aucune catégorie disponible'),
            ),
          );
        }

        // ✅ Catégorie courante (non-nullable) avec fallback sûr
        final Category currentCategory = categoryId != null
            ? categories.firstWhere(
              (category) => category.id == categoryId,
          orElse: () => categories.first,
        )
            : (ref.watch(selectedCategoryProvider) ?? categories.first);

        // ✅ Synchroniser le provider de sélection si nécessaire (post-frame)
        final selectedCategory = ref.read(selectedCategoryProvider);
        if (selectedCategory?.id != currentCategory.id) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            // print('🔄 CATEGORY CHANGE: Mise à jour sélection pour ${currentCategory.name}');
            ref.read(selectedCategoryProvider.notifier).state = currentCategory;
          });
        }

        // ViewModels pour le template
        final List<CategoryViewModel> categoryModels = categories
            .map(
              (c) => CategoryViewModel(
            id: c.id,
            name: c.name,
            imageUrl: c.coverUrl ?? '',
            color: c.color ?? '#FFFFFF',
            description: c.description,
          ),
        )
            .toList(growable: false);

        final CategoryViewModel currentCategoryModel = CategoryViewModel(
          id: currentCategory.id,
          name: currentCategory.name,
          imageUrl: currentCategory.coverUrl ?? '',
          color: currentCategory.color ?? '#FFFFFF',
          description: currentCategory.description,
        );

        // 🗝️ Re-key du subtree par ville → force un rebuild propre des carrousels quand la ville change
        return KeyedSubtree(
          key: ValueKey<String>('category_template_city_${city?.id ?? 'none'}'),
          child: CategoryPageTemplate(
            currentCategory: currentCategoryModel,
            allCategories: categoryModels,
            onCategorySelected: (selectedCategoryVm) {
              // Trouver la catégorie complète correspondante
              final Category fullCategory = categories.firstWhere(
                    (c) => c.id == selectedCategoryVm.id,
                orElse: () => categories.first,
              );

              // Mettre à jour la sélection
              ref.read(selectedCategoryProvider.notifier).state = fullCategory;
            },
            onSearchTap: () {
              // Action recherche (optionnel)
            },
            openBuilder: (context, action, activity) {
              final experienceItem = ExperienceItem.activity(activity);
              return ExperienceDetailPage(
                experienceItem: experienceItem,
                onClose: action,
              );
            },
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Erreur: $error'),
        ),
      ),
    );
  }

}