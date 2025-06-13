// lib/core/domain/models/config/app_remote_config.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_remote_config.freezed.dart';
part 'app_remote_config.g.dart';

@freezed
class AppRemoteConfig with _$AppRemoteConfig {
  const factory AppRemoteConfig({
    required String key,
    required dynamic value,
    String? minAppVersion,
  }) = _AppRemoteConfig;

  factory AppRemoteConfig.fromJson(Map<String, dynamic> json) =>
      _$AppRemoteConfigFromJson(json);
}