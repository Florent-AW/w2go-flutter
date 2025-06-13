// lib/core/common/constants/subcategory_icons.dart
// Ajouter des mappings pour les catégories principales

import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter/material.dart';

class SubcategoryIcons {
  static final Map<String, IconData> icons = {
    // Icônes existantes
    'moon-star': LucideIcons.moonStar,
    'bird': LucideIcons.bird,
    'bike': LucideIcons.bike,
    'wine': LucideIcons.wine,
    'utensils-crossed': LucideIcons.utensilsCrossed,
    'sparkles': LucideIcons.sparkles,
    'palette': LucideIcons.palette,
    'spa': LucideIcons.flower2,
    'droplet': LucideIcons.droplet,
    'home': LucideIcons.home,
    'cave': LucideIcons.warehouse,
    'castle': LucideIcons.castle,
    'plate': LucideIcons.utensils,
    'party-popper': LucideIcons.partyPopper,
    'mountain': LucideIcons.mountain,
    'map': LucideIcons.map,
    'anchor': LucideIcons.anchor,
    'roller-coaster': LucideIcons.rollerCoaster,
    'plane': LucideIcons.plane,
    'star': LucideIcons.star,
    'key': LucideIcons.key,
    'shopping-bag': LucideIcons.shoppingBag,
    'landmark': LucideIcons.landmark,
    'hammer': LucideIcons.hammer,
    'compass': LucideIcons.compass,

    // Nouvelles icônes pour les catégories principales
    'culture': LucideIcons.landmark,
    'nature': LucideIcons.mountain,
    'gastronomie': LucideIcons.utensilsCrossed,
    'sports': LucideIcons.bike,
    'loisirs': LucideIcons.partyPopper,
    'bien-être': LucideIcons.flower2, // spa
    'bien-etre': LucideIcons.flower2, // variant sans accent
    'détente': LucideIcons.moonStar,
    'detente': LucideIcons.moonStar, // variant sans accent
    'soirée': LucideIcons.wine,
    'soiree': LucideIcons.wine, // variant sans accent
    'événements': LucideIcons.calendar,
    'evenements': LucideIcons.calendar, // variant sans accent
  };

  // Méthode améliorée pour la recherche d'icônes
  static IconData getIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return LucideIcons.activity;
    }

    // Normaliser le nom pour la recherche
    final normalized = iconName.toLowerCase()
        .replaceAll(' ', '-')
        .replaceAll('&', 'et')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e');

    // Rechercher l'icône exacte
    if (icons.containsKey(normalized)) {
      return icons[normalized]!;
    }

    // Rechercher par correspondance partielle
    for (var entry in icons.entries) {
      if (normalized.contains(entry.key) || entry.key.contains(normalized)) {
        return entry.value;
      }
    }

    // Icône par défaut
    return LucideIcons.activity;
  }
}