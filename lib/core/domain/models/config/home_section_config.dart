// lib/core/domain/models/config/home_section_config.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'home_section_config.freezed.dart';
part 'home_section_config.g.dart';

@freezed
class HomeSectionConfig with _$HomeSectionConfig {
  const factory HomeSectionConfig({
    required String id,
    required String title,
    // Utiliser le JsonConverter personnalisé pour gérer correctement le queryFilter
    @QueryFilterConverter() required dynamic queryFilter,
    String? iconUrl,
    required int priority,
    required String minAppVersion,
  }) = _HomeSectionConfig;

  factory HomeSectionConfig.fromJson(Map<String, dynamic> json) =>
      _$HomeSectionConfigFromJson(json);
}


/// Convertisseur spécial pour gérer le champ queryFilter qui peut être
/// soit une String JSON, soit directement un Map venant de Supabase
class QueryFilterConverter implements JsonConverter<dynamic, dynamic> {
  const QueryFilterConverter();

  @override
  dynamic fromJson(dynamic json) {
    // Conserver le format original tel que reçu
    return json;
  }

  @override
  dynamic toJson(dynamic object) {
    // Si c'est déjà une String JSON, la retourner directement
    if (object is String) {
      return object;
    }

    // Si c'est un Map, le convertir en JSON
    if (object is Map) {
      return jsonEncode(object);
    }

    // Cas par défaut
    return jsonEncode({});
  }
}