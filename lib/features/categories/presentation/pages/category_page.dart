// lib/features/categories/presentation/pages/category_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../../core/domain/models/shared/category_model.dart';
import '../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../experience_detail/presentation/pages/experience_detail_page.dart';
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

        // Déterminer la catégorie à afficher
        Category? currentCategory;

        if (categoryId != null) {
          // Chercher la catégorie par ID
          currentCategory = categories.firstWhere(
                (category) => category.id == categoryId,
            orElse: () => categories.first,
          );
        } else {
          // Utiliser la catégorie sélectionnée ou la première
          currentCategory = ref.watch(selectedCategoryProvider) ?? categories.first;
        }

        // Mettre à jour la catégorie sélectionnée si nécessaire
        final selectedCategory = ref.read(selectedCategoryProvider);
        if (selectedCategory?.id != currentCategory.id) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedCategoryProvider.notifier).state = currentCategory;
          });
        }

        // Convertir les catégories au format attendu par le template
        final categoryModels = categories.map((category) =>
            CategoryViewModel(
              id: category.id,
              name: category.name,
              imageUrl: category.coverUrl ?? '',
              color: category.color ?? '#FFFFFF',
              description: category.description,
            )
        ).toList();

        final currentCategoryModel = CategoryViewModel(
          id: currentCategory.id,
          name: currentCategory.name,
          imageUrl: currentCategory.coverUrl ?? '',
          color: currentCategory.color ?? '#FFFFFF',
          description: currentCategory.description,
        );

        return CategoryPageTemplate(
          currentCategory: currentCategoryModel,
          allCategories: categoryModels,
          onCategorySelected: (selectedCategory) {
            // Trouver la catégorie complète
            final fullCategory = categories.firstWhere(
                  (c) => c.id == selectedCategory.id,
              orElse: () => categories.first,
            );

            // Mettre à jour la sélection
            ref.read(selectedCategoryProvider.notifier).state = fullCategory;
          },
          onSearchTap: () {
            // Action de recherche à implémenter
            // print('Recherche tappée dans la catégorie: ${currentCategory.name}');
          },
          openBuilder: (context, action, activity) {
            // ✅ Créer ExperienceItem unifié
            final experienceItem = ExperienceItem.activity(activity);

            return ExperienceDetailPage(
              experienceItem: experienceItem,
              onClose: action,
            );
          },
        );      },
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