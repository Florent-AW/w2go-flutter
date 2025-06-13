// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subcategory_section_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubcategorySectionConfig _$SubcategorySectionConfigFromJson(
    Map<String, dynamic> json) {
  return _SubcategorySectionConfig.fromJson(json);
}

/// @nodoc
mixin _$SubcategorySectionConfig {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get queryFilter => throw _privateConstructorUsedError;
  String? get subcategoryId =>
      throw _privateConstructorUsedError; // Nullable car peut être null pour config par défaut
  int get priority => throw _privateConstructorUsedError;
  String get minAppVersion => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this SubcategorySectionConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubcategorySectionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubcategorySectionConfigCopyWith<SubcategorySectionConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubcategorySectionConfigCopyWith<$Res> {
  factory $SubcategorySectionConfigCopyWith(SubcategorySectionConfig value,
          $Res Function(SubcategorySectionConfig) then) =
      _$SubcategorySectionConfigCopyWithImpl<$Res, SubcategorySectionConfig>;
  @useResult
  $Res call(
      {String id,
      String title,
      String queryFilter,
      String? subcategoryId,
      int priority,
      String minAppVersion,
      bool isDefault});
}

/// @nodoc
class _$SubcategorySectionConfigCopyWithImpl<$Res,
        $Val extends SubcategorySectionConfig>
    implements $SubcategorySectionConfigCopyWith<$Res> {
  _$SubcategorySectionConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubcategorySectionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? queryFilter = null,
    Object? subcategoryId = freezed,
    Object? priority = null,
    Object? minAppVersion = null,
    Object? isDefault = null,
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
      queryFilter: null == queryFilter
          ? _value.queryFilter
          : queryFilter // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      minAppVersion: null == minAppVersion
          ? _value.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubcategorySectionConfigImplCopyWith<$Res>
    implements $SubcategorySectionConfigCopyWith<$Res> {
  factory _$$SubcategorySectionConfigImplCopyWith(
          _$SubcategorySectionConfigImpl value,
          $Res Function(_$SubcategorySectionConfigImpl) then) =
      __$$SubcategorySectionConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String queryFilter,
      String? subcategoryId,
      int priority,
      String minAppVersion,
      bool isDefault});
}

/// @nodoc
class __$$SubcategorySectionConfigImplCopyWithImpl<$Res>
    extends _$SubcategorySectionConfigCopyWithImpl<$Res,
        _$SubcategorySectionConfigImpl>
    implements _$$SubcategorySectionConfigImplCopyWith<$Res> {
  __$$SubcategorySectionConfigImplCopyWithImpl(
      _$SubcategorySectionConfigImpl _value,
      $Res Function(_$SubcategorySectionConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubcategorySectionConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? queryFilter = null,
    Object? subcategoryId = freezed,
    Object? priority = null,
    Object? minAppVersion = null,
    Object? isDefault = null,
  }) {
    return _then(_$SubcategorySectionConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      queryFilter: null == queryFilter
          ? _value.queryFilter
          : queryFilter // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      minAppVersion: null == minAppVersion
          ? _value.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubcategorySectionConfigImpl implements _SubcategorySectionConfig {
  const _$SubcategorySectionConfigImpl(
      {required this.id,
      required this.title,
      required this.queryFilter,
      this.subcategoryId,
      required this.priority,
      required this.minAppVersion,
      this.isDefault = false});

  factory _$SubcategorySectionConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubcategorySectionConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String queryFilter;
  @override
  final String? subcategoryId;
// Nullable car peut être null pour config par défaut
  @override
  final int priority;
  @override
  final String minAppVersion;
  @override
  @JsonKey()
  final bool isDefault;

  @override
  String toString() {
    return 'SubcategorySectionConfig(id: $id, title: $title, queryFilter: $queryFilter, subcategoryId: $subcategoryId, priority: $priority, minAppVersion: $minAppVersion, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubcategorySectionConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.queryFilter, queryFilter) ||
                other.queryFilter == queryFilter) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.minAppVersion, minAppVersion) ||
                other.minAppVersion == minAppVersion) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, queryFilter,
      subcategoryId, priority, minAppVersion, isDefault);

  /// Create a copy of SubcategorySectionConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubcategorySectionConfigImplCopyWith<_$SubcategorySectionConfigImpl>
      get copyWith => __$$SubcategorySectionConfigImplCopyWithImpl<
          _$SubcategorySectionConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubcategorySectionConfigImplToJson(
      this,
    );
  }
}

abstract class _SubcategorySectionConfig implements SubcategorySectionConfig {
  const factory _SubcategorySectionConfig(
      {required final String id,
      required final String title,
      required final String queryFilter,
      final String? subcategoryId,
      required final int priority,
      required final String minAppVersion,
      final bool isDefault}) = _$SubcategorySectionConfigImpl;

  factory _SubcategorySectionConfig.fromJson(Map<String, dynamic> json) =
      _$SubcategorySectionConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get queryFilter;
  @override
  String?
      get subcategoryId; // Nullable car peut être null pour config par défaut
  @override
  int get priority;
  @override
  String get minAppVersion;
  @override
  bool get isDefault;

  /// Create a copy of SubcategorySectionConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubcategorySectionConfigImplCopyWith<_$SubcategorySectionConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}
