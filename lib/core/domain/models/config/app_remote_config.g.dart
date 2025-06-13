// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_remote_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppRemoteConfigImpl _$$AppRemoteConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$AppRemoteConfigImpl(
      key: json['key'] as String,
      value: json['value'],
      minAppVersion: json['minAppVersion'] as String?,
    );

Map<String, dynamic> _$$AppRemoteConfigImplToJson(
        _$AppRemoteConfigImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'minAppVersion': instance.minAppVersion,
    };
