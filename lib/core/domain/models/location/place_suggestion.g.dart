// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceSuggestionImpl _$$PlaceSuggestionImplFromJson(
        Map<String, dynamic> json) =>
    _$PlaceSuggestionImpl(
      placeId: json['placeId'] as String,
      primaryText: json['primaryText'] as String,
      secondaryText: json['secondaryText'] as String?,
      isFromCache: json['isFromCache'] as bool? ?? false,
    );

Map<String, dynamic> _$$PlaceSuggestionImplToJson(
        _$PlaceSuggestionImpl instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'primaryText': instance.primaryText,
      'secondaryText': instance.secondaryText,
      'isFromCache': instance.isFromCache,
    };
