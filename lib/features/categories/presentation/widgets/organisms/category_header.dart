// lib/features/categories/presentation/widgets/organisms/category_header.dart

import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../shared_ui/presentation/widgets/atoms.dart';
import '../../../../shared_ui/presentation/widgets/index.dart';
import '../../../../shared_ui/presentation/widgets/molecules/city_picker.dart';
import '../../../../shared_ui/presentation/widgets/molecules/search_button.dart';


class CategoryHeader extends ConsumerWidget {
  final String? title;
  final VoidCallback? onSearchTap;
  // Ajouter un paramètre pour l'état de défilement
  final bool isScrolled;

  const CategoryHeader({
    Key? key,
    this.title,
    this.onSearchTap,
    this.isScrolled = false, // Par défaut, non défilé
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // City picker à gauche
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.mapPin,
              size: 20,
              color: AppColors.accent,
            ),
            const SizedBox(width: 0),
            const CityPicker(),
          ],
        ),

        // Espace au centre
        Spacer(),

        // Bouton de recherche à droite
        SearchButton(
          onTap: onSearchTap ?? () {
            print('Recherche tappée');
          },
        ),
      ],
    );
  }
}