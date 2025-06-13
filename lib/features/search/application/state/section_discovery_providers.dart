// lib/features/search/application/state/section_discovery_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/search/config/section_metadata.dart';
import '../../../../core/domain/ports/providers/config/sections_discovery_provider.dart';

/// Provider qui expose les métadonnées des sections de type "subcategory"
/// EXCLUANT les sections spécifiques à une catégorie
final subcategorySectionsProvider = FutureProvider<List<SectionMetadata>>((ref) async {
  ref.keepAlive();

  final discoveryService = ref.read(sectionsDiscoveryProvider);
  final allSections = await discoveryService.getSectionsByType('subcategory');

  // ✅ FILTRAGE CLEAN : Seulement les sections génériques (categoryId == null)
  final genericSections = allSections
      .where((section) => section.categoryId == null)
      .toList();

  // Tri des sections par priorité
  genericSections.sort((a, b) => a.priority.compareTo(b.priority));

  print('📊 Sections génériques: ${genericSections.length}');
  print('📊 Titres: ${genericSections.map((s) => s.title).join(", ")}');

  return genericSections;
});
/// Provider qui expose les métadonnées d'une section par son ID
final sectionMetadataProvider = FutureProvider.family<SectionMetadata?, String>((ref, sectionId) async {
  final discoveryService = ref.read(sectionsDiscoveryProvider);
  return discoveryService.getSectionById(sectionId);
});

/// Provider qui expose la section "featured" (par catégorie)
final featuredSectionProvider = FutureProvider<SectionMetadata?>((ref) async {
  final discoveryService = ref.read(sectionsDiscoveryProvider);
  final featuredSections = await discoveryService.getSectionsByType('featured');

  if (featuredSections.isEmpty) {
    print('⚠️ Aucune section featured trouvée');
    return null;
  }

// Prendre la section avec la priority la plus basse (au lieu de displayOrder)
  featuredSections.sort((a, b) => a.priority.compareTo(b.priority));
  return featuredSections.first;
});

/// Provider intelligent avec fallback : spécifique → générique
final effectiveSubcategorySectionsProvider = FutureProvider.family<List<SectionMetadata>, String?>((ref, categoryId) async {
  ref.keepAlive();

  final discoveryService = ref.read(sectionsDiscoveryProvider);
  final allSections = await discoveryService.getSectionsByType('subcategory');

  // Découpe spécifiques vs génériques
  final specifics = allSections.where((s) => s.categoryId == categoryId).toList();
  final generics = allSections.where((s) => s.categoryId == null).toList();

  // ✅ RÈGLE INTELLIGENTE : spécifique sinon générique
  final effectiveSections = specifics.isNotEmpty ? specifics : generics;

  // Tri par priorité
  effectiveSections.sort((a, b) => a.priority.compareTo(b.priority));

  print('📊 Sections pour catégorie $categoryId:');
  print('   - Spécifiques: ${specifics.length} (${specifics.map((s) => s.title).join(", ")})');
  print('   - Génériques: ${generics.length} (${generics.map((s) => s.title).join(", ")})');
  print('   - Utilisées: ${effectiveSections.length} (${effectiveSections.map((s) => s.title).join(", ")})');

  return effectiveSections;
});

