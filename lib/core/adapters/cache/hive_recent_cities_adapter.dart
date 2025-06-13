// lib/core/adapters/cache/hive_recent_cities_adapter.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../../domain/models/search/recent_city.dart';
import '../../domain/ports/search/recent_cities_port.dart';

class HiveRecentCitiesAdapter implements RecentCitiesPort {
  static const String _boxName = 'recentCities';
  late Box<String> _box;

  /// Initialise l'adaptateur et ouvre la boîte Hive
  Future<void> initializeAsync() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<String>(_boxName);
    } else {
      _box = Hive.box<String>(_boxName);
    }
  }

  @override
  Future<List<RecentCity>> getRecentCities({int limit = 5}) async {
    if (!_box.isOpen) await initializeAsync();

    final List<RecentCity> recentCities = [];

    // Parcourir toutes les entrées et les désérialiser
    for (var i = 0; i < _box.length; i++) {
      try {
        final jsonString = _box.getAt(i);
        if (jsonString != null) {
          final Map<String, dynamic> json = jsonDecode(jsonString);
          recentCities.add(RecentCity.fromJson(json));
        }
      } catch (e) {
        print('Erreur lors de la désérialisation: $e');
        // Continuer avec les autres entrées
      }
    }

    // Trier par timestamp décroissant (plus récent en premier)
    recentCities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Limiter le nombre de résultats
    return recentCities.take(limit).toList();
  }

  @override
  Future<void> addRecentCity(RecentCity recentCity) async {
    if (!_box.isOpen) await initializeAsync();

    // Vérifier si la ville existe déjà (par ID)
    final existingCities = await getRecentCities(limit: 100);
    final cityId = recentCity.city.id;

    // Supprimer l'ancienne entrée si elle existe
    for (var i = 0; i < _box.length; i++) {
      try {
        final jsonString = _box.getAt(i);
        if (jsonString != null) {
          final Map<String, dynamic> json = jsonDecode(jsonString);
          final existingCity = RecentCity.fromJson(json);

          if (existingCity.city.id == cityId) {
            await _box.deleteAt(i);
            break;
          }
        }
      } catch (e) {
        // Ignorer les erreurs et continuer
      }
    }

    // Ajouter la nouvelle entrée
    final jsonString = jsonEncode(recentCity.toJson());
    await _box.add(jsonString);

    // Garder uniquement les 5 entrées les plus récentes
    if (_box.length > 5) {
      final citiesToKeep = await getRecentCities(limit: 5);
      await clearRecentCities();

      for (final city in citiesToKeep) {
        final jsonString = jsonEncode(city.toJson());
        await _box.add(jsonString);
      }
    }
  }

  @override
  Future<void> clearRecentCities() async {
    if (!_box.isOpen) await initializeAsync();
    await _box.clear();
  }
}