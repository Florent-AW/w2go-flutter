// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImageImpl _$$EventImageImplFromJson(Map<String, dynamic> json) =>
    _$EventImageImpl(
      id: json['id'] as String,
      mobileUrl: json['mobileUrl'] as String?,
      isMain: json['isMain'] as bool? ?? false,
    );

Map<String, dynamic> _$$EventImageImplToJson(_$EventImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mobileUrl': instance.mobileUrl,
      'isMain': instance.isMain,
    };
