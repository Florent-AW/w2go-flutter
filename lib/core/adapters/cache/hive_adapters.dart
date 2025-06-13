// lib/core/adapters/cache/hive_adapters.dart

import 'package:hive/hive.dart';
import '../../../core/domain/models/location/user_location.dart';
import '../../../core/domain/models/location/place_details.dart';
import '../../../core/domain/models/location/place_suggestion.dart';

// Définition des ID d'adaptateurs (doivent être uniques)
const int userLocationTypeId = 1;
const int placeDetailsTypeId = 2;
const int placeSuggestionTypeId = 3;

// Adaptateur pour convertir UserLocation en format Hive
class UserLocationAdapter extends TypeAdapter<UserLocation> {
  @override
  final int typeId = userLocationTypeId;

  @override
  UserLocation read(BinaryReader reader) {
    final map = reader.readMap();
    return UserLocation(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      accuracy: map['accuracy'] as double?,
      isFromGps: map['isFromGps'] as bool? ?? false,
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, UserLocation obj) {
    writer.writeMap({
      'latitude': obj.latitude,
      'longitude': obj.longitude,
      'accuracy': obj.accuracy,
      'isFromGps': obj.isFromGps,
      'timestamp': obj.timestamp?.toIso8601String(),
    });
  }
}

// Adaptateur pour PlaceDetails
class PlaceDetailsAdapter extends TypeAdapter<PlaceDetails> {
  @override
  final int typeId = placeDetailsTypeId;

  @override
  PlaceDetails read(BinaryReader reader) {
    final map = reader.readMap();
    return PlaceDetails(
      placeId: map['placeId'] as String,
      name: map['name'] as String,
      formattedAddress: map['formattedAddress'] as String,
      location: map['location'] as UserLocation,
      country: map['country'] as String?,
      administrativeArea: map['administrativeArea'] as String?,
      locality: map['locality'] as String?,
      postalCode: map['postalCode'] as String?,
      lastUpdated: map['lastUpdated'] != null
          ? DateTime.parse(map['lastUpdated'] as String)
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, PlaceDetails obj) {
    writer.writeMap({
      'placeId': obj.placeId,
      'name': obj.name,
      'formattedAddress': obj.formattedAddress,
      'location': obj.location,
      'country': obj.country,
      'administrativeArea': obj.administrativeArea,
      'locality': obj.locality,
      'postalCode': obj.postalCode,
      'lastUpdated': obj.lastUpdated?.toIso8601String(),
    });
  }
}

// Adaptateur pour PlaceSuggestion
class PlaceSuggestionAdapter extends TypeAdapter<PlaceSuggestion> {
  @override
  final int typeId = placeSuggestionTypeId;

  @override
  PlaceSuggestion read(BinaryReader reader) {
    final map = reader.readMap();
    return PlaceSuggestion(
      placeId: map['placeId'] as String,
      primaryText: map['primaryText'] as String,
      secondaryText: map['secondaryText'] as String?,
      isFromCache: map['isFromCache'] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, PlaceSuggestion obj) {
    writer.writeMap({
      'placeId': obj.placeId,
      'primaryText': obj.primaryText,
      'secondaryText': obj.secondaryText,
      'isFromCache': obj.isFromCache,
    });
  }
}