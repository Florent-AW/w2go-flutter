// lib/core/adapters/supabase/config/remote_config_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/models/config/home_section_config.dart';
import '../../../domain/models/config/app_remote_config.dart';
import '../../../domain/ports/config/remote_config_port.dart';
import '../../../domain/models/config/subcategory_section_config.dart';


class SupabaseRemoteConfigAdapter implements RemoteConfigPort {
  final SupabaseClient _client;

  SupabaseRemoteConfigAdapter(this._client);

// Dans SupabaseRemoteConfigAdapter, modifiez la méthode getHomeSections:

  @override
  Future<List<HomeSectionConfig>> getHomeSections() async {
    try {
      print('🔄 Calling Supabase home_sections');
      final response = await _client
          .from('home_sections')
          .select()
          .order('priority');
      print('📬 Raw Supabase response: $response');

      if (response == null) return [];

      final List<HomeSectionConfig> sections = (response as List).map((data) {
        print('🔍 Processing data: $data');

        // MODIFICATION CRITIQUE: ne pas appeler toString() sur query_filter
        // pour préserver l'objet Map tel quel
        return HomeSectionConfig(
          id: data['id']?.toString() ?? '',
          title: data['title']?.toString() ?? '',
          queryFilter: data['query_filter'] ?? {}, // Ne pas convertir en String
          iconUrl: data['icon_url']?.toString(),
          priority: data['priority'] as int? ?? 0,
          minAppVersion: data['min_app_version']?.toString() ?? '1.0.0',
        );
      }).toList();

      print('✅ Created sections: $sections');
      return sections;
    } catch (e, stack) {
      print('❌ Error in getHomeSections: $e');
      print('📜 Stack trace: $stack');
      rethrow;
    }
  }

  @override
  Future<List<AppRemoteConfig>> getAppConfig() async {
    final response = await _client
        .from('app_remote_config')
        .select();

    return response.map((json) => AppRemoteConfig.fromJson(json)).toList();
  }

  @override
  Future<List<SubcategorySectionConfig>> getSubcategorySections(String? subcategoryId) async {
    try {
      print('🔄 Calling Supabase subcategory_sections');

      // Construction de la requête de base
      var query = _client
          .from('subcategory_sections')
          .select();

      if (subcategoryId != null) {
        // Si un subcategoryId est fourni, on cherche d'abord les configurations spécifiques
        query = query.or('subcategory_id.eq.$subcategoryId,is_default.eq.true');
      } else {
        // Sinon, on ne prend que les configurations par défaut
        query = query.eq('is_default', true);
      }

      final response = await query.order('priority');
      print('📬 Raw Supabase response: $response');

      if (response == null) return [];

      final List<SubcategorySectionConfig> sections = (response as List).map((data) {
        print('🔍 Processing data: $data');
        return SubcategorySectionConfig(
          id: data['id']?.toString() ?? '',
          title: data['title']?.toString() ?? '',
          queryFilter: data['query_filter']?.toString() ?? '{}',
          subcategoryId: data['subcategory_id']?.toString(),
          priority: data['priority'] as int? ?? 0,
          minAppVersion: data['min_app_version']?.toString() ?? '1.0.0',
          isDefault: data['is_default'] as bool? ?? false,
        );
      }).toList();

      // Si on a un subcategoryId, on priorise les configurations spécifiques
      if (subcategoryId != null) {
        // Trier pour avoir les configs spécifiques avant les configs par défaut
        sections.sort((a, b) {
          if (a.subcategoryId == subcategoryId && b.subcategoryId != subcategoryId) return -1;
          if (a.subcategoryId != subcategoryId && b.subcategoryId == subcategoryId) return 1;
          return a.priority.compareTo(b.priority);
        });

        // Pour chaque priorité, ne garder que la première config (spécifique si elle existe, sinon défaut)
        final uniqueSections = <SubcategorySectionConfig>[];
        final seenPriorities = <int>{};

        for (var section in sections) {
          if (!seenPriorities.contains(section.priority)) {
            uniqueSections.add(section);
            seenPriorities.add(section.priority);
          }
        }

        return uniqueSections;
      }

      print('✅ Created sections: $sections');
      return sections;
    } catch (e, stack) {
      print('❌ Error in getSubcategorySections: $e');
      print('📜 Stack trace: $stack');
      rethrow;
    }
  }


}