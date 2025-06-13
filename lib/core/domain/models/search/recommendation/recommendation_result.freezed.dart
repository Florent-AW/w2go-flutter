// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendationResult _$RecommendationResultFromJson(Map<String, dynamic> json) {
  return _RecommendationResult.fromJson(json);
}

/// @nodoc
mixin _$RecommendationResult {
  List<SearchableActivity> get activities =>
      throw _privateConstructorUsedError; // Pool d'activités
  int get totalFound =>
      throw _privateConstructorUsedError; // Nombre total trouvé
  String get sectionType =>
      throw _privateConstructorUsedError; // Type de section
  String? get sectionTitle =>
      throw _privateConstructorUsedError; // Titre depuis Supabase
  int? get configLimit =>
      throw _privateConstructorUsedError; // Limite depuis config
  String? get cacheKey =>
      throw _privateConstructorUsedError; // Clé cache (debug)
  DateTime? get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this RecommendationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationResultCopyWith<RecommendationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationResultCopyWith<$Res> {
  factory $RecommendationResultCopyWith(RecommendationResult value,
          $Res Function(RecommendationResult) then) =
      _$RecommendationResultCopyWithImpl<$Res, RecommendationResult>;
  @useResult
  $Res call(
      {List<SearchableActivity> activities,
      int totalFound,
      String sectionType,
      String? sectionTitle,
      int? configLimit,
      String? cacheKey,
      DateTime? generatedAt});
}

/// @nodoc
class _$RecommendationResultCopyWithImpl<$Res,
        $Val extends RecommendationResult>
    implements $RecommendationResultCopyWith<$Res> {
  _$RecommendationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
    Object? totalFound = null,
    Object? sectionType = null,
    Object? sectionTitle = freezed,
    Object? configLimit = freezed,
    Object? cacheKey = freezed,
    Object? generatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      activities: null == activities
          ? _value.activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<SearchableActivity>,
      totalFound: null == totalFound
          ? _value.totalFound
          : totalFound // ignore: cast_nullable_to_non_nullable
              as int,
      sectionType: null == sectionType
          ? _value.sectionType
          : sectionType // ignore: cast_nullable_to_non_nullable
              as String,
      sectionTitle: freezed == sectionTitle
          ? _value.sectionTitle
          : sectionTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      configLimit: freezed == configLimit
          ? _value.configLimit
          : configLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      cacheKey: freezed == cacheKey
          ? _value.cacheKey
          : cacheKey // ignore: cast_nullable_to_non_nullable
              as String?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendationResultImplCopyWith<$Res>
    implements $RecommendationResultCopyWith<$Res> {
  factory _$$RecommendationResultImplCopyWith(_$RecommendationResultImpl value,
          $Res Function(_$RecommendationResultImpl) then) =
      __$$RecommendationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SearchableActivity> activities,
      int totalFound,
      String sectionType,
      String? sectionTitle,
      int? configLimit,
      String? cacheKey,
      DateTime? generatedAt});
}

/// @nodoc
class __$$RecommendationResultImplCopyWithImpl<$Res>
    extends _$RecommendationResultCopyWithImpl<$Res, _$RecommendationResultImpl>
    implements _$$RecommendationResultImplCopyWith<$Res> {
  __$$RecommendationResultImplCopyWithImpl(_$RecommendationResultImpl _value,
      $Res Function(_$RecommendationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
    Object? totalFound = null,
    Object? sectionType = null,
    Object? sectionTitle = freezed,
    Object? configLimit = freezed,
    Object? cacheKey = freezed,
    Object? generatedAt = freezed,
  }) {
    return _then(_$RecommendationResultImpl(
      activities: null == activities
          ? _value._activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<SearchableActivity>,
      totalFound: null == totalFound
          ? _value.totalFound
          : totalFound // ignore: cast_nullable_to_non_nullable
              as int,
      sectionType: null == sectionType
          ? _value.sectionType
          : sectionType // ignore: cast_nullable_to_non_nullable
              as String,
      sectionTitle: freezed == sectionTitle
          ? _value.sectionTitle
          : sectionTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      configLimit: freezed == configLimit
          ? _value.configLimit
          : configLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      cacheKey: freezed == cacheKey
          ? _value.cacheKey
          : cacheKey // ignore: cast_nullable_to_non_nullable
              as String?,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendationResultImpl implements _RecommendationResult {
  const _$RecommendationResultImpl(
      {required final List<SearchableActivity> activities,
      required this.totalFound,
      required this.sectionType,
      this.sectionTitle,
      this.configLimit,
      this.cacheKey,
      this.generatedAt})
      : _activities = activities;

  factory _$RecommendationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendationResultImplFromJson(json);

  final List<SearchableActivity> _activities;
  @override
  List<SearchableActivity> get activities {
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activities);
  }

// Pool d'activités
  @override
  final int totalFound;
// Nombre total trouvé
  @override
  final String sectionType;
// Type de section
  @override
  final String? sectionTitle;
// Titre depuis Supabase
  @override
  final int? configLimit;
// Limite depuis config
  @override
  final String? cacheKey;
// Clé cache (debug)
  @override
  final DateTime? generatedAt;

  @override
  String toString() {
    return 'RecommendationResult(activities: $activities, totalFound: $totalFound, sectionType: $sectionType, sectionTitle: $sectionTitle, configLimit: $configLimit, cacheKey: $cacheKey, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationResultImpl &&
            const DeepCollectionEquality()
                .equals(other._activities, _activities) &&
            (identical(other.totalFound, totalFound) ||
                other.totalFound == totalFound) &&
            (identical(other.sectionType, sectionType) ||
                other.sectionType == sectionType) &&
            (identical(other.sectionTitle, sectionTitle) ||
                other.sectionTitle == sectionTitle) &&
            (identical(other.configLimit, configLimit) ||
                other.configLimit == configLimit) &&
            (identical(other.cacheKey, cacheKey) ||
                other.cacheKey == cacheKey) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_activities),
      totalFound,
      sectionType,
      sectionTitle,
      configLimit,
      cacheKey,
      generatedAt);

  /// Create a copy of RecommendationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationResultImplCopyWith<_$RecommendationResultImpl>
      get copyWith =>
          __$$RecommendationResultImplCopyWithImpl<_$RecommendationResultImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationResultImplToJson(
      this,
    );
  }
}

abstract class _RecommendationResult implements RecommendationResult {
  const factory _RecommendationResult(
      {required final List<SearchableActivity> activities,
      required final int totalFound,
      required final String sectionType,
      final String? sectionTitle,
      final int? configLimit,
      final String? cacheKey,
      final DateTime? generatedAt}) = _$RecommendationResultImpl;

  factory _RecommendationResult.fromJson(Map<String, dynamic> json) =
      _$RecommendationResultImpl.fromJson;

  @override
  List<SearchableActivity> get activities; // Pool d'activités
  @override
  int get totalFound; // Nombre total trouvé
  @override
  String get sectionType; // Type de section
  @override
  String? get sectionTitle; // Titre depuis Supabase
  @override
  int? get configLimit; // Limite depuis config
  @override
  String? get cacheKey; // Clé cache (debug)
  @override
  DateTime? get generatedAt;

  /// Create a copy of RecommendationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationResultImplCopyWith<_$RecommendationResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
