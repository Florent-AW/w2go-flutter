// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaceSuggestion _$PlaceSuggestionFromJson(Map<String, dynamic> json) {
  return _PlaceSuggestion.fromJson(json);
}

/// @nodoc
mixin _$PlaceSuggestion {
  String get placeId => throw _privateConstructorUsedError;
  String get primaryText => throw _privateConstructorUsedError;
  String? get secondaryText => throw _privateConstructorUsedError;
  bool get isFromCache => throw _privateConstructorUsedError;

  /// Serializes this PlaceSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaceSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaceSuggestionCopyWith<PlaceSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceSuggestionCopyWith<$Res> {
  factory $PlaceSuggestionCopyWith(
          PlaceSuggestion value, $Res Function(PlaceSuggestion) then) =
      _$PlaceSuggestionCopyWithImpl<$Res, PlaceSuggestion>;
  @useResult
  $Res call(
      {String placeId,
      String primaryText,
      String? secondaryText,
      bool isFromCache});
}

/// @nodoc
class _$PlaceSuggestionCopyWithImpl<$Res, $Val extends PlaceSuggestion>
    implements $PlaceSuggestionCopyWith<$Res> {
  _$PlaceSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaceSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? primaryText = null,
    Object? secondaryText = freezed,
    Object? isFromCache = null,
  }) {
    return _then(_value.copyWith(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      primaryText: null == primaryText
          ? _value.primaryText
          : primaryText // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryText: freezed == secondaryText
          ? _value.secondaryText
          : secondaryText // ignore: cast_nullable_to_non_nullable
              as String?,
      isFromCache: null == isFromCache
          ? _value.isFromCache
          : isFromCache // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaceSuggestionImplCopyWith<$Res>
    implements $PlaceSuggestionCopyWith<$Res> {
  factory _$$PlaceSuggestionImplCopyWith(_$PlaceSuggestionImpl value,
          $Res Function(_$PlaceSuggestionImpl) then) =
      __$$PlaceSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String placeId,
      String primaryText,
      String? secondaryText,
      bool isFromCache});
}

/// @nodoc
class __$$PlaceSuggestionImplCopyWithImpl<$Res>
    extends _$PlaceSuggestionCopyWithImpl<$Res, _$PlaceSuggestionImpl>
    implements _$$PlaceSuggestionImplCopyWith<$Res> {
  __$$PlaceSuggestionImplCopyWithImpl(
      _$PlaceSuggestionImpl _value, $Res Function(_$PlaceSuggestionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlaceSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? primaryText = null,
    Object? secondaryText = freezed,
    Object? isFromCache = null,
  }) {
    return _then(_$PlaceSuggestionImpl(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      primaryText: null == primaryText
          ? _value.primaryText
          : primaryText // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryText: freezed == secondaryText
          ? _value.secondaryText
          : secondaryText // ignore: cast_nullable_to_non_nullable
              as String?,
      isFromCache: null == isFromCache
          ? _value.isFromCache
          : isFromCache // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceSuggestionImpl implements _PlaceSuggestion {
  const _$PlaceSuggestionImpl(
      {required this.placeId,
      required this.primaryText,
      this.secondaryText,
      this.isFromCache = false});

  factory _$PlaceSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceSuggestionImplFromJson(json);

  @override
  final String placeId;
  @override
  final String primaryText;
  @override
  final String? secondaryText;
  @override
  @JsonKey()
  final bool isFromCache;

  @override
  String toString() {
    return 'PlaceSuggestion(placeId: $placeId, primaryText: $primaryText, secondaryText: $secondaryText, isFromCache: $isFromCache)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceSuggestionImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.primaryText, primaryText) ||
                other.primaryText == primaryText) &&
            (identical(other.secondaryText, secondaryText) ||
                other.secondaryText == secondaryText) &&
            (identical(other.isFromCache, isFromCache) ||
                other.isFromCache == isFromCache));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, placeId, primaryText, secondaryText, isFromCache);

  /// Create a copy of PlaceSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceSuggestionImplCopyWith<_$PlaceSuggestionImpl> get copyWith =>
      __$$PlaceSuggestionImplCopyWithImpl<_$PlaceSuggestionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceSuggestionImplToJson(
      this,
    );
  }
}

abstract class _PlaceSuggestion implements PlaceSuggestion {
  const factory _PlaceSuggestion(
      {required final String placeId,
      required final String primaryText,
      final String? secondaryText,
      final bool isFromCache}) = _$PlaceSuggestionImpl;

  factory _PlaceSuggestion.fromJson(Map<String, dynamic> json) =
      _$PlaceSuggestionImpl.fromJson;

  @override
  String get placeId;
  @override
  String get primaryText;
  @override
  String? get secondaryText;
  @override
  bool get isFromCache;

  /// Create a copy of PlaceSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaceSuggestionImplCopyWith<_$PlaceSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
