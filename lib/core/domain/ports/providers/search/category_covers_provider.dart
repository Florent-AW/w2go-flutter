// lib/core/domain/ports/providers/search/category_covers_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../adapters/supabase/search/category_covers_adapter.dart';
import '../../../../domain/models/shared/category_view_model.dart';
import '../../../../domain/ports/search/category_covers_port.dart';
import '../../../../../features/search/application/state/city_selection_state.dart';

// Provider pour l'adapter des couvertures
final categoryCoversPortProvider = Provider<CategoryCoversPort>((ref) {
  return CategoryCoversAdapter();
});

// Fonction utilitaire pour extraire le département d'un code postal
String? _extractDepartmentCode(String? postalCode) {
  if (postalCode == null || postalCode.length < 2) return null;
  return postalCode.substring(0, 2);
}

/// Provider pour récupérer l'URL de couverture optimale pour une catégorie
/// selon le département de la ville actuellement sélectionnée
final categoryDepartmentCoverProvider = FutureProvider.family<String, CategoryViewModel>(
        (ref, category) async {
      final adapter = ref.watch(categoryCoversPortProvider);
      final selectedCity = ref.watch(selectedCityProvider);

      // Si pas de ville sélectionnée, utiliser l'image par défaut
      if (selectedCity == null) {
        return category.imageUrl;
      }

      // Extraire le code du département du code postal de la ville
      final departmentCode = _extractDepartmentCode(selectedCity.postalCode);
      if (departmentCode == null) {
        return category.imageUrl;
      }

      // Tenter de récupérer une image spécifique au département
      final departmentCover = await adapter.getCoverUrlForCategoryAndDepartment(
          category.id,
          departmentCode
      );

      // Retourner l'image spécifique ou l'image par défaut
      return departmentCover ?? category.imageUrl;
    }
);

/// Provider pour récupérer la description optimale pour une catégorie
/// selon le département de la ville actuellement sélectionnée
final categoryDepartmentDescriptionProvider = FutureProvider.family<String, CategoryViewModel>(
        (ref, category) async {
      final adapter = ref.watch(categoryCoversPortProvider);
      final selectedCity = ref.watch(selectedCityProvider);

      // Si pas de ville sélectionnée, utiliser la description par défaut
      if (selectedCity == null) {
        return category.description ?? '';
      }

      // Extraire le code du département du code postal de la ville
      final departmentCode = _extractDepartmentCode(selectedCity.postalCode);
      if (departmentCode == null) {
        return category.description ?? '';
      }

      // Tenter de récupérer une description spécifique au département
      final departmentDescription = await adapter.getDescriptionForCategoryAndDepartment(
          category.id,
          departmentCode
      );

      // Retourner la description spécifique ou la description par défaut
      return departmentDescription ?? category.description ?? '';
    }
);