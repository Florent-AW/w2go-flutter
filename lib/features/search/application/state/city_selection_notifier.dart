// lib/features/search/application/state/city_selection_notifier.dart

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../../../../core/domain/models/shared/city_model.dart';

class CitySelectionNotifier extends StateNotifier<City?> {
  CitySelectionNotifier() : super(null);

  /// Définit la ville sélectionnée - méthode idempotente
  void selectCity(City? city) {
    // Mise à jour de l'état
    state = city;

    // Persistance
    if (city != null) {
      _persistSelectedCity(city);
    }
  }

  void reset() {
    state = null;
  }

  /// Réinitialise la sélection - méthode idempotente
  void clearSelection() {
    // Ne réinitialise que si l'état n'est pas déjà null
    if (state != null) {
      state = null;
    }
  }
}

/// Persiste la ville sélectionnée dans Hive pour la retrouver entre les sessions
void _persistSelectedCity(City? city) async {
  if (city == null) return;

  try {
    final Box<String> cityBox = await Hive.openBox<String>('cityPreferences');
    final cityJson = jsonEncode(city.toJson());
    await cityBox.put('selectedCity', cityJson);
  } catch (e) {
    print('Erreur lors de la persistance de la ville: $e');
  }
}


/// Provider principal pour le notifier
final citySelectionNotifierProvider = StateNotifierProvider<CitySelectionNotifier, City?>(
      (ref) => CitySelectionNotifier(),
);

/// Selector pour vérifier si une ville est sélectionnée
final hasCitySelectedProvider = Provider<bool>((ref) {
  return ref.watch(citySelectionNotifierProvider) != null;
});

/// Selector pour obtenir le nom de la ville
final cityNameProvider = Provider<String?>((ref) {
  return ref.watch(citySelectionNotifierProvider)?.cityName;
});

/// Selector pour obtenir la position de la ville
final cityPositionProvider = Provider<({double lat, double lon})?>((ref) {
  final city = ref.watch(citySelectionNotifierProvider);
  if (city == null) return null;

  return (lat: city.lat, lon: city.lon);
});