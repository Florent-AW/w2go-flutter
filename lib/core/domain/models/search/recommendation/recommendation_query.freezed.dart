// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendationQuery _$RecommendationQueryFromJson(Map<String, dynamic> json) {
  return _RecommendationQuery.fromJson(json);
}

/// @nodoc
mixin _$RecommendationQuery {
  String get sectionType =>
      throw _privateConstructorUsedError; // ✅ Seul required
  int? get limit =>
      throw _privateConstructorUsedError; // ✅ Optionnel (config Supabase)
  bool? get excludeCurrentActivity => throw _privateConstructorUsedError;
  String? get orderBy =>
      throw _privateConstructorUsedError; // 'rating_avg', 'rating_count'
  String? get orderDirection =>
      throw _privateConstructorUsedError; // 'DESC', 'ASC'
  double? get maxDistanceKm =>
      throw _privateConstructorUsedError; // pour nearby
  bool? get sameSubcategory =>
      throw _privateConstructorUsedError; // pour similar
  double? get minRating => throw _privateConstructorUsedError; // filtre qualité
  String? get rotation =>
      throw _privateConstructorUsedError; // 'none' | 'daily'
  bool? get randomSample => throw _privateConstructorUsedError;

  /// Serializes this RecommendationQuery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationQueryCopyWith<RecommendationQuery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationQueryCopyWith<$Res> {
  factory $RecommendationQueryCopyWith(
          RecommendationQuery value, $Res Function(RecommendationQuery) then) =
      _$RecommendationQueryCopyWithImpl<$Res, RecommendationQuery>;
  @useResult
  $Res call(
      {String sectionType,
      int? limit,
      bool? excludeCurrentActivity,
      String? orderBy,
      String? orderDirection,
      double? maxDistanceKm,
      bool? sameSubcategory,
      double? minRating,
      String? rotation,
      bool? randomSample});
}

/// @nodoc
class _$RecommendationQueryCopyWithImpl<$Res, $Val extends RecommendationQuery>
    implements $RecommendationQueryCopyWith<$Res> {
  _$RecommendationQueryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionType = null,
    Object? limit = freezed,
    Object? excludeCurrentActivity = freezed,
    Object? orderBy = freezed,
    Object? orderDirection = freezed,
    Object? maxDistanceKm = freezed,
    Object? sameSubcategory = freezed,
    Object? minRating = freezed,
    Object? rotation = freezed,
    Object? randomSample = freezed,
  }) {
    return _then(_value.copyWith(
      sectionType: null == sectionType
          ? _value.sectionType
          : sectionType // ignore: cast_nullable_to_non_nullable
              as String,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
      excludeCurrentActivity: freezed == excludeCurrentActivity
          ? _value.excludeCurrentActivity
          : excludeCurrentActivity // ignore: cast_nullable_to_non_nullable
              as bool?,
      orderBy: freezed == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as String?,
      orderDirection: freezed == orderDirection
          ? _value.orderDirection
          : orderDirection // ignore: cast_nullable_to_non_nullable
              as String?,
      maxDistanceKm: freezed == maxDistanceKm
          ? _value.maxDistanceKm
          : maxDistanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      sameSubcategory: freezed == sameSubcategory
          ? _value.sameSubcategory
          : sameSubcategory // ignore: cast_nullable_to_non_nullable
              as bool?,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      rotation: freezed == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as String?,
      randomSample: freezed == randomSample
          ? _value.randomSample
          : randomSample // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationQueryImplCopyWith<$Res>
    implements $RecommendationQueryCopyWith<$Res> {
  factory _$$RecommendationQueryImplCopyWith(_$RecommendationQueryImpl value,
          $Res Function(_$RecommendationQueryImpl) then) =
      __$$RecommendationQueryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sectionType,
      int? limit,
      bool? excludeCurrentActivity,
      String? orderBy,
      String? orderDirection,
      double? maxDistanceKm,
      bool? sameSubcategory,
      double? minRating,
      String? rotation,
      bool? randomSample});
}

/// @nodoc
class __$$RecommendationQueryImplCopyWithImpl<$Res>
    extends _$RecommendationQueryCopyWithImpl<$Res, _$RecommendationQueryImpl>
    implements _$$RecommendationQueryImplCopyWith<$Res> {
  __$$RecommendationQueryImplCopyWithImpl(_$RecommendationQueryImpl _value,
      $Res Function(_$RecommendationQueryImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionType = null,
    Object? limit = freezed,
    Object? excludeCurrentActivity = freezed,
    Object? orderBy = freezed,
    Object? orderDirection = freezed,
    Object? maxDistanceKm = freezed,
    Object? sameSubcategory = freezed,
    Object? minRating = freezed,
    Object? rotation = freezed,
    Object? randomSample = freezed,
  }) {
    return _then(_$RecommendationQueryImpl(
      sectionType: null == sectionType
          ? _value.sectionType
          : sectionType // ignore: cast_nullable_to_non_nullable
              as String,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
      excludeCurrentActivity: freezed == excludeCurrentActivity
          ? _value.excludeCurrentActivity
          : excludeCurrentActivity // ignore: cast_nullable_to_non_nullable
              as bool?,
      orderBy: freezed == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as String?,
      orderDirection: freezed == orderDirection
          ? _value.orderDirection
          : orderDirection // ignore: cast_nullable_to_non_nullable
              as String?,
      maxDistanceKm: freezed == maxDistanceKm
          ? _value.maxDistanceKm
          : maxDistanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      sameSubcategory: freezed == sameSubcategory
          ? _value.sameSubcategory
          : sameSubcategory // ignore: cast_nullable_to_non_nullable
              as bool?,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      rotation: freezed == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as String?,
      randomSample: freezed == randomSample
          ? _value.randomSample
          : randomSample // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationQueryImpl implements _RecommendationQuery {
  const _$RecommendationQueryImpl(
      {required this.sectionType,
      this.limit,
      this.excludeCurrentActivity,
      this.orderBy,
      this.orderDirection,
      this.maxDistanceKm,
      this.sameSubcategory,
      this.minRating,
      this.rotation,
      this.randomSample});

  factory _$RecommendationQueryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationQueryImplFromJson(json);

  @override
  final String sectionType;
// ✅ Seul required
  @override
  final int? limit;
// ✅ Optionnel (config Supabase)
  @override
  final bool? excludeCurrentActivity;
  @override
  final String? orderBy;
// 'rating_avg', 'rating_count'
  @override
  final String? orderDirection;
// 'DESC', 'ASC'
  @override
  final double? maxDistanceKm;
// pour nearby
  @override
  final bool? sameSubcategory;
// pour similar
  @override
  final double? minRating;
// filtre qualité
  @override
  final String? rotation;
// 'none' | 'daily'
  @override
  final bool? randomSample;

  @override
  String toString() {
    return 'RecommendationQuery(sectionType: $sectionType, limit: $limit, excludeCurrentActivity: $excludeCurrentActivity, orderBy: $orderBy, orderDirection: $orderDirection, maxDistanceKm: $maxDistanceKm, sameSubcategory: $sameSubcategory, minRating: $minRating, rotation: $rotation, randomSample: $randomSample)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationQueryImpl &&
            (identical(other.sectionType, sectionType) ||
                other.sectionType == sectionType) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.excludeCurrentActivity, excludeCurrentActivity) ||
                other.excludeCurrentActivity == excludeCurrentActivity) &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy) &&
            (identical(other.orderDirection, orderDirection) ||
                other.orderDirection == orderDirection) &&
            (identical(other.maxDistanceKm, maxDistanceKm) ||
                other.maxDistanceKm == maxDistanceKm) &&
            (identical(other.sameSubcategory, sameSubcategory) ||
                other.sameSubcategory == sameSubcategory) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            (identical(other.rotation, rotation) ||
                other.rotation == rotation) &&
            (identical(other.randomSample, randomSample) ||
                other.randomSample == randomSample));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sectionType,
      limit,
      excludeCurrentActivity,
      orderBy,
      orderDirection,
      maxDistanceKm,
      sameSubcategory,
      minRating,
      rotation,
      randomSample);

  /// Create a copy of RecommendationQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationQueryImplCopyWith<_$RecommendationQueryImpl> get copyWith =>
      __$$RecommendationQueryImplCopyWithImpl<_$RecommendationQueryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationQueryImplToJson(
      this,
    );
  }
}

abstract class _RecommendationQuery implements RecommendationQuery {
  const factory _RecommendationQuery(
      {required final String sectionType,
      final int? limit,
      final bool? excludeCurrentActivity,
      final String? orderBy,
      final String? orderDirection,
      final double? maxDistanceKm,
      final bool? sameSubcategory,
      final double? minRating,
      final String? rotation,
      final bool? randomSample}) = _$RecommendationQueryImpl;

  factory _RecommendationQuery.fromJson(Map<String, dynamic> json) =
      _$RecommendationQueryImpl.fromJson;

  @override
  String get sectionType; // ✅ Seul required
  @override
  int? get limit; // ✅ Optionnel (config Supabase)
  @override
  bool? get excludeCurrentActivity;
  @override
  String? get orderBy; // 'rating_avg', 'rating_count'
  @override
  String? get orderDirection; // 'DESC', 'ASC'
  @override
  double? get maxDistanceKm; // pour nearby
  @override
  bool? get sameSubcategory; // pour similar
  @override
  double? get minRating; // filtre qualité
  @override
  String? get rotation; // 'none' | 'daily'
  @override
  bool? get randomSample;

  /// Create a copy of RecommendationQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationQueryImplCopyWith<_$RecommendationQueryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
