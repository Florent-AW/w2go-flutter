// lib/core/domain/models/location/place_suggestion.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_suggestion.freezed.dart';
part 'place_suggestion.g.dart';

@freezed
class PlaceSuggestion with _$PlaceSuggestion {
  const factory PlaceSuggestion({
    required String placeId,
    required String primaryText,
    String? secondaryText,
    @Default(false) bool isFromCache,
  }) = _PlaceSuggestion;

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) =>
      _$PlaceSuggestionFromJson(json);
}