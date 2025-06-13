// features/search/application/state/city_selection_state.dart
import 'package:riverpod/riverpod.dart';
import '../../../../core/domain/models/shared/city_model.dart';

class CitySelectionNotifier extends StateNotifier<City?> {
  CitySelectionNotifier([City? initialCity]) : super(initialCity);

  void selectCity(City? city) {
    state = city;
  }

  void reset() {
    state = null;
  }
}

// Provider unique
final selectedCityProvider = StateNotifierProvider<CitySelectionNotifier, City?>((ref) {
  return CitySelectionNotifier();
});

// Sélecteurs pratiques
final hasCitySelectedProvider = Provider<bool>((ref) {
  return ref.watch(selectedCityProvider) != null;
});

final cityNameProvider = Provider<String?>((ref) {
  return ref.watch(selectedCityProvider)?.cityName;
});