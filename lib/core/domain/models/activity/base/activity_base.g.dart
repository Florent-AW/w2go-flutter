// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityBaseImpl _$$ActivityBaseImplFromJson(Map<String, dynamic> json) =>
    _$ActivityBaseImpl(
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
      bookingRequired: json['bookingRequired'] as bool? ?? false,
    );

Map<String, dynamic> _$$ActivityBaseImplToJson(_$ActivityBaseImpl instance) =>
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
      'bookingRequired': instance.bookingRequired,
    };
