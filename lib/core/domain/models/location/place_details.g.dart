// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceDetailsImpl _$$PlaceDetailsImplFromJson(Map<String, dynamic> json) =>
    _$PlaceDetailsImpl(
      placeId: json['placeId'] as String,
      formattedAddress: json['formattedAddress'] as String,
      name: json['name'] as String,
      location: UserLocation.fromJson(json['location'] as Map<String, dynamic>),
      country: json['country'] as String?,
      administrativeArea: json['administrativeArea'] as String?,
      locality: json['locality'] as String?,
      postalCode: json['postalCode'] as String?,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      addressComponents: (json['addressComponents'] as List<dynamic>?)
          ?.map((e) => AddressComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PlaceDetailsImplToJson(_$PlaceDetailsImpl instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'formattedAddress': instance.formattedAddress,
      'name': instance.name,
      'location': instance.location,
      'country': instance.country,
      'administrativeArea': instance.administrativeArea,
      'locality': instance.locality,
      'postalCode': instance.postalCode,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'addressComponents': instance.addressComponents,
    };

_$AddressComponentImpl _$$AddressComponentImplFromJson(
        Map<String, dynamic> json) =>
    _$AddressComponentImpl(
      longName: json['longName'] as String,
      shortName: json['shortName'] as String,
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$AddressComponentImplToJson(
        _$AddressComponentImpl instance) =>
    <String, dynamic>{
      'longName': instance.longName,
      'shortName': instance.shortName,
      'types': instance.types,
    };
