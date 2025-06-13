// lib/core/domain/ports/location/activity_distance_manager_port.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Port pour la gestion centralisée des distances d'activités
///
/// Définit le contrat pour :
/// - Calcul de distances avec cache intelligent
/// - Position de référence unifiée (ville → GPS fallback)
/// - API générique pour tous les cas d'usage
/// - Gestion optimisée du cache et invalidation
abstract class ActivityDistanceManagerPort {
  /// Récupère la distance d'une activité avec cache optimisé
  ///
  /// [activityId] : ID unique de l'activité pour mise en cache
  /// [activityLat] : Latitude de l'activité
  /// [activityLon] : Longitude de l'activité
  /// [referencePosition] : Position de référence optionnelle (ville sélectionnée)
  ///
  /// Retourne la distance en mètres ou null en cas d'erreur
  Future<double?> getActivityDistance({
    required String activityId,
    required double activityLat,
    required double activityLon,
    LatLng? referencePosition,
  });

  /// Calcule la distance depuis la position de référence (usage générique)
  ///
  /// Pour les cas où on n'a pas besoin de cache (calculs ponctuels)
  ///
  /// [targetLat] : Latitude destination
  /// [targetLon] : Longitude destination
  /// [referencePosition] : Position de référence optionnelle
  ///
  /// Retourne la distance en mètres ou null en cas d'erreur
  Future<double?> calculateDistanceFromReference({
    required double targetLat,
    required double targetLon,
    LatLng? referencePosition,
  });

  /// Obtient la position de référence centralisée
  ///
  /// Logique prioritaire : Position ville sélectionnée → GPS utilisateur
  /// Avec cache TTL pour éviter les recalculs fréquents
  ///
  /// Retourne les coordonnées de référence ou null si indisponible
  Future<LatLng?> getReferencePosition();

  /// Pré-calcule les distances pour un lot d'activités
  ///
  /// Optimisation pour les listes/carousels avec plusieurs activités
  ///
  /// [activities] : Liste des activités avec coordonnées
  /// [referencePosition] : Position de référence optionnelle
  ///
  /// Retourne Map<activityId, distance> des distances calculées
  Future<Map<String, double>> batchCalculateDistances({
    required List<({String id, double lat, double lon})> activities,
    LatLng? referencePosition,
  });

  /// Invalide tout le cache des distances
  ///
  /// À utiliser quand la position de référence change significativement
  void invalidateCache();

  /// Invalide le cache d'une activité spécifique
  ///
  /// [activityId] : ID de l'activité dont supprimer le cache
  void clearActivityCache(String activityId);

  /// Invalide le cache de position de référence
  ///
  /// Utile quand l'utilisateur change de ville sélectionnée
  /// Invalide automatiquement le cache des activités car référence changée
  void invalidateReferencePosition();

  /// Obtient les statistiques du cache (debug/monitoring)
  ///
  /// Retourne info sur taille cache, âge position référence, etc.
  Map<String, dynamic> getCacheStats();
}