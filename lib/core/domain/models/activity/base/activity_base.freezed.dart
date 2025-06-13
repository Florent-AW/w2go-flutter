// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_base.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActivityBase _$ActivityBaseFromJson(Map<String, dynamic> json) {
  return _ActivityBase.fromJson(json);
}

/// @nodoc
mixin _$ActivityBase {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String? get subcategoryId => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool get isWow => throw _privateConstructorUsedError;
  double? get basePrice => throw _privateConstructorUsedError;
  double get ratingAvg => throw _privateConstructorUsedError;
  int get ratingCount => throw _privateConstructorUsedError;
  bool get kidFriendly => throw _privateConstructorUsedError;
  String? get wheelchairAccessible => throw _privateConstructorUsedError;
  bool get bookingRequired => throw _privateConstructorUsedError;

  /// Serializes this ActivityBase to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityBase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityBaseCopyWith<ActivityBase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityBaseCopyWith<$Res> {
  factory $ActivityBaseCopyWith(
          ActivityBase value, $Res Function(ActivityBase) then) =
      _$ActivityBaseCopyWithImpl<$Res, ActivityBase>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      double latitude,
      double longitude,
      String categoryId,
      String? subcategoryId,
      String? city,
      String? imageUrl,
      bool isWow,
      double? basePrice,
      double ratingAvg,
      int ratingCount,
      bool kidFriendly,
      String? wheelchairAccessible,
      bool bookingRequired});
}

/// @nodoc
class _$ActivityBaseCopyWithImpl<$Res, $Val extends ActivityBase>
    implements $ActivityBaseCopyWith<$Res> {
  _$ActivityBaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityBase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? categoryId = null,
    Object? subcategoryId = freezed,
    Object? city = freezed,
    Object? imageUrl = freezed,
    Object? isWow = null,
    Object? basePrice = freezed,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? kidFriendly = null,
    Object? wheelchairAccessible = freezed,
    Object? bookingRequired = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isWow: null == isWow
          ? _value.isWow
          : isWow // ignore: cast_nullable_to_non_nullable
              as bool,
      basePrice: freezed == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      ratingAvg: null == ratingAvg
          ? _value.ratingAvg
          : ratingAvg // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      kidFriendly: null == kidFriendly
          ? _value.kidFriendly
          : kidFriendly // ignore: cast_nullable_to_non_nullable
              as bool,
      wheelchairAccessible: freezed == wheelchairAccessible
          ? _value.wheelchairAccessible
          : wheelchairAccessible // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingRequired: null == bookingRequired
          ? _value.bookingRequired
          : bookingRequired // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityBaseImplCopyWith<$Res>
    implements $ActivityBaseCopyWith<$Res> {
  factory _$$ActivityBaseImplCopyWith(
          _$ActivityBaseImpl value, $Res Function(_$ActivityBaseImpl) then) =
      __$$ActivityBaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      double latitude,
      double longitude,
      String categoryId,
      String? subcategoryId,
      String? city,
      String? imageUrl,
      bool isWow,
      double? basePrice,
      double ratingAvg,
      int ratingCount,
      bool kidFriendly,
      String? wheelchairAccessible,
      bool bookingRequired});
}

/// @nodoc
class __$$ActivityBaseImplCopyWithImpl<$Res>
    extends _$ActivityBaseCopyWithImpl<$Res, _$ActivityBaseImpl>
    implements _$$ActivityBaseImplCopyWith<$Res> {
  __$$ActivityBaseImplCopyWithImpl(
      _$ActivityBaseImpl _value, $Res Function(_$ActivityBaseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityBase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? categoryId = null,
    Object? subcategoryId = freezed,
    Object? city = freezed,
    Object? imageUrl = freezed,
    Object? isWow = null,
    Object? basePrice = freezed,
    Object? ratingAvg = null,
    Object? ratingCount = null,
    Object? kidFriendly = null,
    Object? wheelchairAccessible = freezed,
    Object? bookingRequired = null,
  }) {
    return _then(_$ActivityBaseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isWow: null == isWow
          ? _value.isWow
          : isWow // ignore: cast_nullable_to_non_nullable
              as bool,
      basePrice: freezed == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      ratingAvg: null == ratingAvg
          ? _value.ratingAvg
          : ratingAvg // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      kidFriendly: null == kidFriendly
          ? _value.kidFriendly
          : kidFriendly // ignore: cast_nullable_to_non_nullable
              as bool,
      wheelchairAccessible: freezed == wheelchairAccessible
          ? _value.wheelchairAccessible
          : wheelchairAccessible // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingRequired: null == bookingRequired
          ? _value.bookingRequired
          : bookingRequired // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityBaseImpl implements _ActivityBase {
  const _$ActivityBaseImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.latitude,
      required this.longitude,
      required this.categoryId,
      this.subcategoryId,
      this.city,
      this.imageUrl,
      this.isWow = false,
      this.basePrice,
      this.ratingAvg = 0.0,
      this.ratingCount = 0,
      this.kidFriendly = false,
      this.wheelchairAccessible,
      this.bookingRequired = false});

  factory _$ActivityBaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityBaseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String categoryId;
  @override
  final String? subcategoryId;
  @override
  final String? city;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final bool isWow;
  @override
  final double? basePrice;
  @override
  @JsonKey()
  final double ratingAvg;
  @override
  @JsonKey()
  final int ratingCount;
  @override
  @JsonKey()
  final bool kidFriendly;
  @override
  final String? wheelchairAccessible;
  @override
  @JsonKey()
  final bool bookingRequired;

  @override
  String toString() {
    return 'ActivityBase(id: $id, name: $name, description: $description, latitude: $latitude, longitude: $longitude, categoryId: $categoryId, subcategoryId: $subcategoryId, city: $city, imageUrl: $imageUrl, isWow: $isWow, basePrice: $basePrice, ratingAvg: $ratingAvg, ratingCount: $ratingCount, kidFriendly: $kidFriendly, wheelchairAccessible: $wheelchairAccessible, bookingRequired: $bookingRequired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityBaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isWow, isWow) || other.isWow == isWow) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.ratingAvg, ratingAvg) ||
                other.ratingAvg == ratingAvg) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.kidFriendly, kidFriendly) ||
                other.kidFriendly == kidFriendly) &&
            (identical(other.wheelchairAccessible, wheelchairAccessible) ||
                other.wheelchairAccessible == wheelchairAccessible) &&
            (identical(other.bookingRequired, bookingRequired) ||
                other.bookingRequired == bookingRequired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      latitude,
      longitude,
      categoryId,
      subcategoryId,
      city,
      imageUrl,
      isWow,
      basePrice,
      ratingAvg,
      ratingCount,
      kidFriendly,
      wheelchairAccessible,
      bookingRequired);

  /// Create a copy of ActivityBase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityBaseImplCopyWith<_$ActivityBaseImpl> get copyWith =>
      __$$ActivityBaseImplCopyWithImpl<_$ActivityBaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityBaseImplToJson(
      this,
    );
  }
}

abstract class _ActivityBase implements ActivityBase {
  const factory _ActivityBase(
      {required final String id,
      required final String name,
      required final String? description,
      required final double latitude,
      required final double longitude,
      required final String categoryId,
      final String? subcategoryId,
      final String? city,
      final String? imageUrl,
      final bool isWow,
      final double? basePrice,
      final double ratingAvg,
      final int ratingCount,
      final bool kidFriendly,
      final String? wheelchairAccessible,
      final bool bookingRequired}) = _$ActivityBaseImpl;

  factory _ActivityBase.fromJson(Map<String, dynamic> json) =
      _$ActivityBaseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get categoryId;
  @override
  String? get subcategoryId;
  @override
  String? get city;
  @override
  String? get imageUrl;
  @override
  bool get isWow;
  @override
  double? get basePrice;
  @override
  double get ratingAvg;
  @override
  int get ratingCount;
  @override
  bool get kidFriendly;
  @override
  String? get wheelchairAccessible;
  @override
  bool get bookingRequired;

  /// Create a copy of ActivityBase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityBaseImplCopyWith<_$ActivityBaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
