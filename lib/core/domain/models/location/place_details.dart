// lib/core/domain/models/location/place_details.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_location.dart';

part 'place_details.freezed.dart';
part 'place_details.g.dart';

@freezed
class PlaceDetails with _$PlaceDetails {
  const factory PlaceDetails({
    required String placeId,
    required String formattedAddress,
    required String name,
    required UserLocation location,
    String? country,
    String? administrativeArea,
    String? locality,
    String? postalCode,
    DateTime? lastUpdated,
    List<AddressComponent>? addressComponents, // Nouveau champ ajouté
  }) = _PlaceDetails;

  factory PlaceDetails.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailsFromJson(json);
}

// Ajout de la nouvelle classe pour les composants d'adresse
@freezed
class AddressComponent with _$AddressComponent {
  const factory AddressComponent({
    required String longName,
    required String shortName,
    required List<String> types,
  }) = _AddressComponent;

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      _$AddressComponentFromJson(json);
}