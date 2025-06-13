// lib/core/domain/ports/config/sections_discovery_port.dart

import '../../../models/search/config/section_metadata.dart';

abstract class SectionsDiscoveryPort {
  /// Récupère toutes les sections d'un type spécifique
  Future<List<SectionMetadata>> getSectionsByType(String sectionType);

  /// Récupère une section spécifique par son ID
  Future<SectionMetadata?> getSectionById(String sectionId);
}