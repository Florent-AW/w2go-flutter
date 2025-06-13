// lib/features/search/application/state/city_picker_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/models/shared/city_model.dart';

part 'city_picker_state.freezed.dart';

@freezed
class CityPickerState with _$CityPickerState {
  const factory CityPickerState.initial() = _Initial;

  const factory CityPickerState.loading() = _Loading;

  const factory CityPickerState.loaded({
    required List<City> cities,
    required String query,
    City? selectedCity,
  }) = _Loaded;

  const factory CityPickerState.error(String message) = _Error;
}