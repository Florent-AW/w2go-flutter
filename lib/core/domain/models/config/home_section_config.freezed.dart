// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_section_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HomeSectionConfig _$HomeSectionConfigFromJson(Map<String, dynamic> json) {
  return _HomeSectionConfig.fromJson(json);
}

/// @nodoc
mixin _$HomeSectionConfig {
  String get id => throw _privateConstructorUsedError;
  String get title =>
      throw _privateConstructorUsedError; // Utiliser le JsonConverter personnalisé pour gérer correctement le queryFilter
  @QueryFilterConverter()
  dynamic get queryFilter => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  String get minAppVersion => throw _privateConstructorUsedError;

  /// Serializes this HomeSectionConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeSectionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeSectionConfigCopyWith<HomeSectionConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeSectionConfigCopyWith<$Res> {
  factory $HomeSectionConfigCopyWith(
          HomeSectionConfig value, $Res Function(HomeSectionConfig) then) =
      _$HomeSectionConfigCopyWithImpl<$Res, HomeSectionConfig>;
  @useResult
  $Res call(
      {String id,
      String title,
      @QueryFilterConverter() dynamic queryFilter,
      String? iconUrl,
      int priority,
      String minAppVersion});
}

/// @nodoc
class _$HomeSectionConfigCopyWithImpl<$Res, $Val extends HomeSectionConfig>
    implements $HomeSectionConfigCopyWith<$Res> {
  _$HomeSectionConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeSectionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? queryFilter = freezed,
    Object? iconUrl = freezed,
    Object? priority = null,
    Object? minAppVersion = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      queryFilter: freezed == queryFilter
          ? _value.queryFilter
          : queryFilter // ignore: cast_nullable_to_non_nullable
              as dynamic,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      minAppVersion: null == minAppVersion
          ? _value.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeSectionConfigImplCopyWith<$Res>
    implements $HomeSectionConfigCopyWith<$Res> {
  factory _$$HomeSectionConfigImplCopyWith(_$HomeSectionConfigImpl value,
          $Res Function(_$HomeSectionConfigImpl) then) =
      __$$HomeSectionConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      @QueryFilterConverter() dynamic queryFilter,
      String? iconUrl,
      int priority,
      String minAppVersion});
}

/// @nodoc
class __$$HomeSectionConfigImplCopyWithImpl<$Res>
    extends _$HomeSectionConfigCopyWithImpl<$Res, _$HomeSectionConfigImpl>
    implements _$$HomeSectionConfigImplCopyWith<$Res> {
  __$$HomeSectionConfigImplCopyWithImpl(_$HomeSectionConfigImpl _value,
      $Res Function(_$HomeSectionConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeSectionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? queryFilter = freezed,
    Object? iconUrl = freezed,
    Object? priority = null,
    Object? minAppVersion = null,
  }) {
    return _then(_$HomeSectionConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      queryFilter: freezed == queryFilter
          ? _value.queryFilter
          : queryFilter // ignore: cast_nullable_to_non_nullable
              as dynamic,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      minAppVersion: null == minAppVersion
          ? _value.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeSectionConfigImpl implements _HomeSectionConfig {
  const _$HomeSectionConfigImpl(
      {required this.id,
      required this.title,
      @QueryFilterConverter() required this.queryFilter,
      this.iconUrl,
      required this.priority,
      required this.minAppVersion});

  factory _$HomeSectionConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeSectionConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
// Utiliser le JsonConverter personnalisé pour gérer correctement le queryFilter
  @override
  @QueryFilterConverter()
  final dynamic queryFilter;
  @override
  final String? iconUrl;
  @override
  final int priority;
  @override
  final String minAppVersion;

  @override
  String toString() {
    return 'HomeSectionConfig(id: $id, title: $title, queryFilter: $queryFilter, iconUrl: $iconUrl, priority: $priority, minAppVersion: $minAppVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeSectionConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other.queryFilter, queryFilter) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.minAppVersion, minAppVersion) ||
                other.minAppVersion == minAppVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      const DeepCollectionEquality().hash(queryFilter),
      iconUrl,
      priority,
      minAppVersion);

  /// Create a copy of HomeSectionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeSectionConfigImplCopyWith<_$HomeSectionConfigImpl> get copyWith =>
      __$$HomeSectionConfigImplCopyWithImpl<_$HomeSectionConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeSectionConfigImplToJson(
      this,
    );
  }
}

abstract class _HomeSectionConfig implements HomeSectionConfig {
  const factory _HomeSectionConfig(
      {required final String id,
      required final String title,
      @QueryFilterConverter() required final dynamic queryFilter,
      final String? iconUrl,
      required final int priority,
      required final String minAppVersion}) = _$HomeSectionConfigImpl;

  factory _HomeSectionConfig.fromJson(Map<String, dynamic> json) =
      _$HomeSectionConfigImpl.fromJson;

  @override
  String get id;
  @override
  String
      get title; // Utiliser le JsonConverter personnalisé pour gérer correctement le queryFilter
  @override
  @QueryFilterConverter()
  dynamic get queryFilter;
  @override
  String? get iconUrl;
  @override
  int get priority;
  @override
  String get minAppVersion;

  /// Create a copy of HomeSectionConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeSectionConfigImplCopyWith<_$HomeSectionConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
