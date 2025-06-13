// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventBaseImpl _$$EventBaseImplFromJson(Map<String, dynamic> json) =>
    _$EventBaseImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      subcategoryId: json['subcategoryId'] as String?,
      city: json['city'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isWow: json['isWow'] as bool? ?? false,
      basePrice: (json['basePrice'] as num?)?.toDouble(),
      ratingAvg: (json['ratingAvg'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      kidFriendly: json['kidFriendly'] as bool? ?? false,
      wheelchairAccessible: json['wheelchairAccessible'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      bookingRequired: json['bookingRequired'] as bool? ?? false,
      hasMultipleOccurrences: json['hasMultipleOccurrences'] as bool? ?? false,
      isRecurring: json['isRecurring'] as bool? ?? false,
    );

Map<String, dynamic> _$$EventBaseImplToJson(_$EventBaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'categoryId': instance.categoryId,
      'subcategoryId': instance.subcategoryId,
      'city': instance.city,
      'imageUrl': instance.imageUrl,
      'isWow': instance.isWow,
      'basePrice': instance.basePrice,
      'ratingAvg': instance.ratingAvg,
      'ratingCount': instance.ratingCount,
      'kidFriendly': instance.kidFriendly,
      'wheelchairAccessible': instance.wheelchairAccessible,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'bookingRequired': instance.bookingRequired,
      'hasMultipleOccurrences': instance.hasMultipleOccurrences,
      'isRecurring': instance.isRecurring,
    };
