// lib/core/domain/services/search/section_config_service.dart

import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/config/home_section_config.dart';
import '../../models/config/subcategory_section_config.dart';

/// Service pour gérer les configurations de sections
/// Utilise la nouvelle architecture avec merged_filter_config
class SectionConfigService {
  final SupabaseClient _client;

  SectionConfigService(this._client);

  /// Récupère la configuration de section fusionnée directement depuis la vue matérialisée
  Future<HomeSectionConfig> getSectionConfig(String sectionId) async {
    try {
      print('🔄 Récupération de la configuration fusionnée pour section: $sectionId');

      // Requête directe à la vue matérialisée
      final response = await _client
          .from('merged_filter_config')
          .select('section_id, title, priority, filter_config')
          .eq('section_id', sectionId)
          .maybeSingle();

      if (response != null) {
        print('✅ Configuration récupérée pour section: ${response['title']}');

        // Transformer en HomeSectionConfig
        return HomeSectionConfig(
          id: response['section_id'],
          title: response['title'] ?? 'Section sans titre',
          queryFilter: response['filter_config'], // JSONB déjà décodé en Map par Supabase
          priority: response['priority'] ?? 0,
          minAppVersion: '1.0.0', // Valeur par défaut
        );
      }

      // Fallback si aucune configuration n'est trouvée
      print('⚠️ Aucune configuration trouvée pour sectionId: $sectionId');
      return _getDefaultSectionConfig(sectionId);
    } catch (e) {
      print('❌ Erreur lors de la récupération de la configuration: $e');
      return _getDefaultSectionConfig(sectionId);
    }
  }

  /// Récupère la configuration de section pour mise en avant par catégorie
  Future<HomeSectionConfig> getFeaturedSectionForCategory(String categoryId) async {
    try {
      // Récupérer la configuration de la section featured
      const String featuredSectionId = 'a62c6046-8814-456f-91ba-b65aa7e73137'; // Section par défaut

      // Utiliser la méthode générique pour récupérer la config
      final config = await getSectionConfig(featuredSectionId);

      // Créer une copie avec le categoryId ajouté
      final dynamic queryFilter = config.queryFilter;
      Map<String, dynamic> updatedFilter;

      if (queryFilter is Map) {
        updatedFilter = Map<String, dynamic>.from(queryFilter);
      } else if (queryFilter is String) {
        try {
          updatedFilter = jsonDecode(queryFilter);
        } catch (_) {
          updatedFilter = {};
        }
      } else {
        updatedFilter = {};
      }

      updatedFilter['categoryId'] = categoryId;

      // Retourner la config mise à jour
      return HomeSectionConfig(
        id: config.id,
        title: config.title,
        queryFilter: updatedFilter,
        iconUrl: config.iconUrl,
        priority: config.priority,
        minAppVersion: config.minAppVersion,
      );
    } catch (e) {
      print('❌ Erreur lors de la récupération de la section mise en avant: $e');

      // Retourner une configuration par défaut en cas d'erreur
      return HomeSectionConfig(
        id: 'default-section',
        title: 'Activités recommandées',
        queryFilter: {
          'categoryId': categoryId,
          'limit': 10,
          'orderBy': 'rating_avg',
          'orderDirection': 'DESC',
        },
        priority: 1,
        minAppVersion: '1.0.0',
      );
    }
  }

  /// Récupère toutes les configurations de sections pour une sous-catégorie
  Future<List<SubcategorySectionConfig>> getSubcategorySections(String subcategoryId) async {
    try {
      // Récupérer les sections pour cette sous-catégorie depuis la vue matérialisée
      final response = await _client
          .from('merged_filter_config')
          .select('section_id, title, priority, filter_config')
          .order('priority', ascending: true)
          .limit(10);

      if (response == null || response.isEmpty) {
        return _getDefaultSubcategorySections(subcategoryId);
      }

      // Construire les configurations à partir de la réponse
      final List<SubcategorySectionConfig> sections = [];
      for (final row in response) {
        // Extraire la config de filtre
        dynamic filterConfig = row['filter_config'];

        // Assurer que c'est une Map<String, dynamic>
        Map<String, dynamic> filterMap;
        if (filterConfig is Map) {
          filterMap = Map<String, dynamic>.from(filterConfig);
        } else {
          filterMap = {};
        }

        // Forcer subcategoryId
        filterMap['subcategoryId'] = subcategoryId;

        // Ajouter la configuration
        sections.add(
          SubcategorySectionConfig(
            id: row['section_id'],
            title: row['title'] ?? 'Section sans titre',
            queryFilter: jsonEncode(filterMap),
            subcategoryId: subcategoryId,
            priority: row['priority'] ?? 999,
            minAppVersion: '1.0.0',
            isDefault: false,
          ),
        );
      }

      return sections;
    } catch (e) {
      print('❌ Erreur lors de la récupération des sections de sous-catégorie: $e');
      return _getDefaultSubcategorySections(subcategoryId);
    }
  }

  // Méthode privée pour créer une configuration par défaut
  HomeSectionConfig _getDefaultSectionConfig(String sectionId) {
    return HomeSectionConfig(
      id: sectionId,
      title: 'Section par défaut',
      queryFilter: {
        'limit': 20,
        'orderBy': 'rating_avg',
        'orderDirection': 'DESC',
        'minRating': 3.5,
      },
      priority: 999,
      minAppVersion: '1.0.0',
    );
  }

  // Méthode privée pour créer des sections par défaut pour une sous-catégorie
  List<SubcategorySectionConfig> _getDefaultSubcategorySections(String subcategoryId) {
    return [
      SubcategorySectionConfig(
        id: 'subcategory-top-rated',
        title: 'Les mieux notées',
        queryFilter: jsonEncode({
          'subcategoryId': subcategoryId,
          'orderBy': 'rating_avg',
          'orderDirection': 'DESC',
          'limit': 10,
        }),
        subcategoryId: subcategoryId,
        priority: 1,
        minAppVersion: '1.0.0',
        isDefault: true,
      ),
      SubcategorySectionConfig(
        id: 'subcategory-nearest',
        title: 'Près de vous',
        queryFilter: jsonEncode({
          'subcategoryId': subcategoryId,
          'orderBy': 'distance',
          'orderDirection': 'ASC',
          'maxDistance': 20,
          'limit': 10,
        }),
        subcategoryId: subcategoryId,
        priority: 2,
        minAppVersion: '1.0.0',
        isDefault: true,
      ),
      SubcategorySectionConfig(
        id: 'subcategory-popular',
        title: 'Les plus populaires',
        queryFilter: jsonEncode({
          'subcategoryId': subcategoryId,
          'orderBy': 'rating_count',
          'orderDirection': 'DESC',
          'limit': 10,
        }),
        subcategoryId: subcategoryId,
        priority: 3,
        minAppVersion: '1.0.0',
        isDefault: true,
      ),
    ];
  }
}