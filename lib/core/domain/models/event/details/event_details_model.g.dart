// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventDetailsImpl _$$EventDetailsImplFromJson(Map<String, dynamic> json) =>
    _$EventDetailsImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String?,
      subcategoryName: json['subcategoryName'] as String?,
      subcategoryIcon: json['subcategoryIcon'] as String?,
      postalCode: json['postalCode'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      googlePlaceId: json['googlePlaceId'] as String?,
      currentOpeningHours: json['currentOpeningHours'] as Map<String, dynamic>?,
      contactPhone: json['contactPhone'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactWebsite: json['contactWebsite'] as String?,
      bookingLevel: json['bookingLevel'] as String?,
      kidFriendly: json['kidFriendly'] as bool?,
      wheelchairAccessible: json['wheelchairAccessible'] as String?,
      minDurationMinutes: (json['minDurationMinutes'] as num?)?.toInt(),
      maxDurationMinutes: (json['maxDurationMinutes'] as num?)?.toInt(),
      priceLevel: (json['priceLevel'] as num?)?.toInt(),
      basePrice: (json['basePrice'] as num?)?.toDouble(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => EventImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      bookingRequired: json['bookingRequired'] as bool? ?? false,
      hasMultipleOccurrences: json['hasMultipleOccurrences'] as bool? ?? false,
      isRecurring: json['isRecurring'] as bool? ?? false,
    );

Map<String, dynamic> _$$EventDetailsImplToJson(_$EventDetailsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'subcategoryName': instance.subcategoryName,
      'subcategoryIcon': instance.subcategoryIcon,
      'postalCode': instance.postalCode,
      'address': instance.address,
      'city': instance.city,
      'googlePlaceId': instance.googlePlaceId,
      'currentOpeningHours': instance.currentOpeningHours,
      'contactPhone': instance.contactPhone,
      'contactEmail': instance.contactEmail,
      'contactWebsite': instance.contactWebsite,
      'bookingLevel': instance.bookingLevel,
      'kidFriendly': instance.kidFriendly,
      'wheelchairAccessible': instance.wheelchairAccessible,
      'minDurationMinutes': instance.minDurationMinutes,
      'maxDurationMinutes': instance.maxDurationMinutes,
      'priceLevel': instance.priceLevel,
      'basePrice': instance.basePrice,
      'images': instance.images,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'bookingRequired': instance.bookingRequired,
      'hasMultipleOccurrences': instance.hasMultipleOccurrences,
      'isRecurring': instance.isRecurring,
    };
