// lib/core/domain/ports/providers/config/section_config_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../domain/models/config/home_section_config.dart';
import '../../../../domain/models/config/subcategory_section_config.dart';
import '../../../../domain/services/search/section_config_service.dart';

/// Provider du service de configuration des sections
/// Utilise directement Supabase sans RemoteConfigPort
final sectionConfigServiceProvider = Provider((ref) {
  final client = Supabase.instance.client;
  return SectionConfigService(client);
});

/// Provider qui récupère directement la section depuis la vue matérialisée
final sectionConfigProvider = FutureProvider.family<HomeSectionConfig, String>((ref, sectionId) async {
  final service = ref.read(sectionConfigServiceProvider);
  return service.getSectionConfig(sectionId);
});

/// Provider pour obtenir la configuration de section mise en avant par catégorie
final featuredSectionForCategoryProvider = FutureProvider.family<HomeSectionConfig, String>(
      (ref, categoryId) async {
    final configService = ref.read(sectionConfigServiceProvider);
    return configService.getFeaturedSectionForCategory(categoryId);
  },
);

/// Provider pour obtenir les configurations de sections pour une sous-catégorie
final sectionConfigForSubcategoryProvider = FutureProvider.family<List<SubcategorySectionConfig>, String?>(
      (ref, subcategoryId) async {
    if (subcategoryId == null) return [];
    final configService = ref.read(sectionConfigServiceProvider);
    return configService.getSubcategorySections(subcategoryId);
  },
);

/// Provider pour obtenir les titres des sections par ID
final sectionTitlesProvider = Provider<Map<String, String>>((ref) {
  // Table de correspondance des ID de section vers leurs titres
  return {
    // Sections spéciales
    'subcategory-top-rated': 'Les mieux notées',
    'subcategory-nearest': 'Près de vous',
    'subcategory-popular': 'Les plus populaires',
    'error-fallback': 'Activités suggérées',
    'default-section': 'Activités recommandées',

    // Sections par défaut
    '1bbdd3e1-cfd4-4324-8b0f-821af25de7e2': 'Les incontournables',
    '7a545088-b0e9-4c6c-8a38-61d4c00b7cb8': 'En famille',
    'a62c6046-8814-456f-91ba-b65aa7e73137': 'Activités par catégorie',
    '709670fb-6ffe-4202-8a9e-93a3c842170b': 'Autour de Moi',
  };
});