// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_remote_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppRemoteConfig _$AppRemoteConfigFromJson(Map<String, dynamic> json) {
  return _AppRemoteConfig.fromJson(json);
}

/// @nodoc
mixin _$AppRemoteConfig {
  String get key => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;
  String? get minAppVersion => throw _privateConstructorUsedError;

  /// Serializes this AppRemoteConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppRemoteConfigCopyWith<AppRemoteConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppRemoteConfigCopyWith<$Res> {
  factory $AppRemoteConfigCopyWith(
          AppRemoteConfig value, $Res Function(AppRemoteConfig) then) =
      _$AppRemoteConfigCopyWithImpl<$Res, AppRemoteConfig>;
  @useResult
  $Res call({String key, dynamic value, String? minAppVersion});
}

/// @nodoc
class _$AppRemoteConfigCopyWithImpl<$Res, $Val extends AppRemoteConfig>
    implements $AppRemoteConfigCopyWith<$Res> {
  _$AppRemoteConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = freezed,
    Object? minAppVersion = freezed,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      minAppVersion: freezed == minAppVersion
          ? _value.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppRemoteConfigImplCopyWith<$Res>
    implements $AppRemoteConfigCopyWith<$Res> {
  factory _$$AppRemoteConfigImplCopyWith(_$AppRemoteConfigImpl value,
          $Res Function(_$AppRemoteConfigImpl) then) =
      __$$AppRemoteConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, dynamic value, String? minAppVersion});
}

/// @nodoc
class __$$AppRemoteConfigImplCopyWithImpl<$Res>
    extends _$AppRemoteConfigCopyWithImpl<$Res, _$AppRemoteConfigImpl>
    implements _$$AppRemoteConfigImplCopyWith<$Res> {
  __$$AppRemoteConfigImplCopyWithImpl(
      _$AppRemoteConfigImpl _value, $Res Function(_$AppRemoteConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = freezed,
    Object? minAppVersion = freezed,
  }) {
    return _then(_$AppRemoteConfigImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      minAppVersion: freezed == minAppVersion
          ? _value.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppRemoteConfigImpl implements _AppRemoteConfig {
  const _$AppRemoteConfigImpl(
      {required this.key, required this.value, this.minAppVersion});

  factory _$AppRemoteConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppRemoteConfigImplFromJson(json);

  @override
  final String key;
  @override
  final dynamic value;
  @override
  final String? minAppVersion;

  @override
  String toString() {
    return 'AppRemoteConfig(key: $key, value: $value, minAppVersion: $minAppVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppRemoteConfigImpl &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.minAppVersion, minAppVersion) ||
                other.minAppVersion == minAppVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key,
      const DeepCollectionEquality().hash(value), minAppVersion);

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppRemoteConfigImplCopyWith<_$AppRemoteConfigImpl> get copyWith =>
      __$$AppRemoteConfigImplCopyWithImpl<_$AppRemoteConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppRemoteConfigImplToJson(
      this,
    );
  }
}

abstract class _AppRemoteConfig implements AppRemoteConfig {
  const factory _AppRemoteConfig(
      {required final String key,
      required final dynamic value,
      final String? minAppVersion}) = _$AppRemoteConfigImpl;

  factory _AppRemoteConfig.fromJson(Map<String, dynamic> json) =
      _$AppRemoteConfigImpl.fromJson;

  @override
  String get key;
  @override
  dynamic get value;
  @override
  String? get minAppVersion;

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppRemoteConfigImplCopyWith<_$AppRemoteConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
