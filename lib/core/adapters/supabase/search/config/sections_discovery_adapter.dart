// lib/core/adapters/supabase/search/config/sections_discovery_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../domain/models/search/config/section_metadata.dart';
import '../../../../domain/ports/search/config/sections_discovery_port.dart';

class SectionsDiscoveryAdapter implements SectionsDiscoveryPort {
  final SupabaseClient _client;

  SectionsDiscoveryAdapter(this._client);

  @override
  Future<List<SectionMetadata>> getSectionsByType(String sectionType) async {
    try {
      // Récupérer depuis la vue matérialisée
      final response = await _client
          .from('merged_filter_config')
          .select('section_id, title, section_type, display_order, priority, category_id') // ✅ AJOUT
          .eq('section_type', sectionType)
          .order('priority', ascending: true);

      final sections = response.map<SectionMetadata>((data) =>
          SectionMetadata(
            id: data['section_id'],
            title: data['title'],
            sectionType: data['section_type'],
            priority: data['priority'] ?? 0,
            categoryId: data['category_id'], // ✅ AJOUT
          )
      ).toList();

      print('📊 Sections récupérées pour le type "$sectionType": ${sections.length}');
      return sections;
    } catch (e) {
      print('❌ Erreur lors de la récupération des sections: $e');
      return [];
    }
  }

  @override
  Future<SectionMetadata?> getSectionById(String sectionId) async {
    try {
      final response = await _client
          .from('merged_filter_config')
          .select('section_id, title, section_type, display_order, priority, category_id') // ✅ AJOUT
          .eq('section_id', sectionId)
          .maybeSingle();

      if (response == null) {
        print('⚠️ Aucune section trouvée pour l\'ID: $sectionId');
        return null;
      }

      return SectionMetadata(
        id: response['section_id'],
        title: response['title'],
        sectionType: response['section_type'] ?? 'unknown',
        priority: response['priority'] ?? 0,
        categoryId: response['category_id'], // ✅ AJOUT
      );
    } catch (e) {
      print('❌ Erreur lors de la récupération de la section: $e');
      return null;
    }
  }
}