// lib/features/search/application/state/place_details_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/models/location/place_details.dart';

part 'place_details_state.freezed.dart';

@freezed
class PlaceDetailsState with _$PlaceDetailsState {
  const factory PlaceDetailsState.initial() = _Initial;
  const factory PlaceDetailsState.loading() = _Loading;
  const factory PlaceDetailsState.loaded(PlaceDetails location) = _Loaded;
  const factory PlaceDetailsState.error(String message) = _Error;
}