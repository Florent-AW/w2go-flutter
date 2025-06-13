// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventImage _$EventImageFromJson(Map<String, dynamic> json) {
  return _EventImage.fromJson(json);
}

/// @nodoc
mixin _$EventImage {
  String get id => throw _privateConstructorUsedError;
  String? get mobileUrl => throw _privateConstructorUsedError;
  bool get isMain => throw _privateConstructorUsedError;

  /// Serializes this EventImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventImageCopyWith<EventImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventImageCopyWith<$Res> {
  factory $EventImageCopyWith(
          EventImage value, $Res Function(EventImage) then) =
      _$EventImageCopyWithImpl<$Res, EventImage>;
  @useResult
  $Res call({String id, String? mobileUrl, bool isMain});
}

/// @nodoc
class _$EventImageCopyWithImpl<$Res, $Val extends EventImage>
    implements $EventImageCopyWith<$Res> {
  _$EventImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mobileUrl = freezed,
    Object? isMain = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mobileUrl: freezed == mobileUrl
          ? _value.mobileUrl
          : mobileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isMain: null == isMain
          ? _value.isMain
          : isMain // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventImageImplCopyWith<$Res>
    implements $EventImageCopyWith<$Res> {
  factory _$$EventImageImplCopyWith(
          _$EventImageImpl value, $Res Function(_$EventImageImpl) then) =
      __$$EventImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String? mobileUrl, bool isMain});
}

/// @nodoc
class __$$EventImageImplCopyWithImpl<$Res>
    extends _$EventImageCopyWithImpl<$Res, _$EventImageImpl>
    implements _$$EventImageImplCopyWith<$Res> {
  __$$EventImageImplCopyWithImpl(
      _$EventImageImpl _value, $Res Function(_$EventImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mobileUrl = freezed,
    Object? isMain = null,
  }) {
    return _then(_$EventImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mobileUrl: freezed == mobileUrl
          ? _value.mobileUrl
          : mobileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isMain: null == isMain
          ? _value.isMain
          : isMain // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventImageImpl implements _EventImage {
  const _$EventImageImpl(
      {required this.id, this.mobileUrl, this.isMain = false});

  factory _$EventImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImageImplFromJson(json);

  @override
  final String id;
  @override
  final String? mobileUrl;
  @override
  @JsonKey()
  final bool isMain;

  @override
  String toString() {
    return 'EventImage(id: $id, mobileUrl: $mobileUrl, isMain: $isMain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mobileUrl, mobileUrl) ||
                other.mobileUrl == mobileUrl) &&
            (identical(other.isMain, isMain) || other.isMain == isMain));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, mobileUrl, isMain);

  /// Create a copy of EventImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImageImplCopyWith<_$EventImageImpl> get copyWith =>
      __$$EventImageImplCopyWithImpl<_$EventImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImageImplToJson(
      this,
    );
  }
}

abstract class _EventImage implements EventImage {
  const factory _EventImage(
      {required final String id,
      final String? mobileUrl,
      final bool isMain}) = _$EventImageImpl;

  factory _EventImage.fromJson(Map<String, dynamic> json) =
      _$EventImageImpl.fromJson;

  @override
  String get id;
  @override
  String? get mobileUrl;
  @override
  bool get isMain;

  /// Create a copy of EventImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventImageImplCopyWith<_$EventImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
