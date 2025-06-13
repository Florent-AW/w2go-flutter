// lib/core/domain/models/search/activity_filter.dart

import 'dart:convert';

/// Modèle de filtre pour la recherche d'activités
/// Encapsule tous les critères possibles et gère la conversion vers les paramètres RPC
class ActivityFilter {
  final String? categoryId;
  final String? subcategoryId;
  final bool? isWow;
  final double? maxDistanceKm;
  final double? minRating;
  final int? minRatingCount;
  final int? maxRatingCount;
  final bool? kidFriendly;
  final String orderBy;
  final String orderDirection;
  final int limit;
  final String? sectionId; // ID de la section pour récupérer la config fusionnée

  const ActivityFilter({
    this.categoryId,
    this.subcategoryId,
    this.isWow,
    this.maxDistanceKm,
    this.minRating,
    this.minRatingCount,
    this.maxRatingCount,
    this.kidFriendly,
    this.orderBy = 'rating_avg',
    this.orderDirection = 'DESC',
    this.limit = 20,
    this.sectionId,
  });

  /// Crée un filtre pour les activités d'une sous-catégorie
  factory ActivityFilter.forSubcategory({
    required String categoryId,
    required String subcategoryId,
    String orderBy = 'rating_avg',
    String orderDirection = 'DESC',
    int limit = 10,
    String? sectionId,
  }) {
    return ActivityFilter(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      orderBy: orderBy,
      orderDirection: orderDirection,
      limit: limit,
      sectionId: sectionId,
    );
  }

  /// Convertit le filtre en paramètres RPC avec les préfixes 'p_' requis
  Map<String, dynamic> toRpcParams({
    required double latitude,
    required double longitude,
    String? cityId,
  }) {
    // Dans la nouvelle approche, nous utilisons principalement section_id
    // Les autres paramètres sont conservés pour compatibilité
    final Map<String, dynamic> params = {
      'p_latitude': latitude,
      'p_longitude': longitude,
      'p_limit': limit,
    };

    // Ajouter section_id s'il est défini
    if (sectionId != null) {
      params['p_section_id'] = sectionId;
    }

    return params;
  }

  /// Crée une copie du filtre avec de nouvelles valeurs
  ActivityFilter copyWith({
    String? categoryId,
    String? subcategoryId,
    bool? isWow,
    double? maxDistanceKm,
    double? minRating,
    int? minRatingCount,
    int? maxRatingCount,
    bool? kidFriendly,
    String? orderBy,
    String? orderDirection,
    int? limit,
    String? sectionId,
  }) {
    return ActivityFilter(
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      isWow: isWow ?? this.isWow,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      minRating: minRating ?? this.minRating,
      minRatingCount: minRatingCount ?? this.minRatingCount,
      maxRatingCount: maxRatingCount ?? this.maxRatingCount,
      kidFriendly: kidFriendly ?? this.kidFriendly,
      orderBy: orderBy ?? this.orderBy,
      orderDirection: orderDirection ?? this.orderDirection,
      limit: limit ?? this.limit,
      sectionId: sectionId ?? this.sectionId,
    );
  }
}