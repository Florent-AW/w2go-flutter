// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActivityImage _$ActivityImageFromJson(Map<String, dynamic> json) {
  return _ActivityImage.fromJson(json);
}

/// @nodoc
mixin _$ActivityImage {
  String? get id => throw _privateConstructorUsedError;
  String? get mobileUrl => throw _privateConstructorUsedError;
  bool? get isMain => throw _privateConstructorUsedError;

  /// Serializes this ActivityImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityImageCopyWith<ActivityImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityImageCopyWith<$Res> {
  factory $ActivityImageCopyWith(
          ActivityImage value, $Res Function(ActivityImage) then) =
      _$ActivityImageCopyWithImpl<$Res, ActivityImage>;
  @useResult
  $Res call({String? id, String? mobileUrl, bool? isMain});
}

/// @nodoc
class _$ActivityImageCopyWithImpl<$Res, $Val extends ActivityImage>
    implements $ActivityImageCopyWith<$Res> {
  _$ActivityImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? mobileUrl = freezed,
    Object? isMain = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileUrl: freezed == mobileUrl
          ? _value.mobileUrl
          : mobileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isMain: freezed == isMain
          ? _value.isMain
          : isMain // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityImageImplCopyWith<$Res>
    implements $ActivityImageCopyWith<$Res> {
  factory _$$ActivityImageImplCopyWith(
          _$ActivityImageImpl value, $Res Function(_$ActivityImageImpl) then) =
      __$$ActivityImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? mobileUrl, bool? isMain});
}

/// @nodoc
class __$$ActivityImageImplCopyWithImpl<$Res>
    extends _$ActivityImageCopyWithImpl<$Res, _$ActivityImageImpl>
    implements _$$ActivityImageImplCopyWith<$Res> {
  __$$ActivityImageImplCopyWithImpl(
      _$ActivityImageImpl _value, $Res Function(_$ActivityImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? mobileUrl = freezed,
    Object? isMain = freezed,
  }) {
    return _then(_$ActivityImageImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      mobileUrl: freezed == mobileUrl
          ? _value.mobileUrl
          : mobileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isMain: freezed == isMain
          ? _value.isMain
          : isMain // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityImageImpl implements _ActivityImage {
  const _$ActivityImageImpl({this.id, this.mobileUrl, this.isMain});

  factory _$ActivityImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityImageImplFromJson(json);

  @override
  final String? id;
  @override
  final String? mobileUrl;
  @override
  final bool? isMain;

  @override
  String toString() {
    return 'ActivityImage(id: $id, mobileUrl: $mobileUrl, isMain: $isMain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mobileUrl, mobileUrl) ||
                other.mobileUrl == mobileUrl) &&
            (identical(other.isMain, isMain) || other.isMain == isMain));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, mobileUrl, isMain);

  /// Create a copy of ActivityImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityImageImplCopyWith<_$ActivityImageImpl> get copyWith =>
      __$$ActivityImageImplCopyWithImpl<_$ActivityImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityImageImplToJson(
      this,
    );
  }
}

abstract class _ActivityImage implements ActivityImage {
  const factory _ActivityImage(
      {final String? id,
      final String? mobileUrl,
      final bool? isMain}) = _$ActivityImageImpl;

  factory _ActivityImage.fromJson(Map<String, dynamic> json) =
      _$ActivityImageImpl.fromJson;

  @override
  String? get id;
  @override
  String? get mobileUrl;
  @override
  bool? get isMain;

  /// Create a copy of ActivityImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityImageImplCopyWith<_$ActivityImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
