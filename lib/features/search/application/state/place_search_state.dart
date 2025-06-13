// lib/features/search/application/state/place_search_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/models/location/place_suggestion.dart';

part 'place_search_state.freezed.dart';

@freezed
class PlaceSearchState with _$PlaceSearchState {
  const factory PlaceSearchState.initial() = _Initial;
  const factory PlaceSearchState.loading() = _Loading;
  const factory PlaceSearchState.loaded(List<PlaceSuggestion> suggestions) = _Loaded;
  const factory PlaceSearchState.noResults() = _NoResults;
  const factory PlaceSearchState.error(String message) = _Error;
}