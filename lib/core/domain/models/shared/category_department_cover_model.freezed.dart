// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_department_cover_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryDepartmentCover _$CategoryDepartmentCoverFromJson(
    Map<String, dynamic> json) {
  return _CategoryDepartmentCover.fromJson(json);
}

/// @nodoc
mixin _$CategoryDepartmentCover {
  String get id => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get departmentCode => throw _privateConstructorUsedError;
  String get departmentName => throw _privateConstructorUsedError;
  String get coverUrl => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // Nouveau champ pour la description
  int get priority => throw _privateConstructorUsedError;

  /// Serializes this CategoryDepartmentCover to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryDepartmentCover
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryDepartmentCoverCopyWith<CategoryDepartmentCover> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryDepartmentCoverCopyWith<$Res> {
  factory $CategoryDepartmentCoverCopyWith(CategoryDepartmentCover value,
          $Res Function(CategoryDepartmentCover) then) =
      _$CategoryDepartmentCoverCopyWithImpl<$Res, CategoryDepartmentCover>;
  @useResult
  $Res call(
      {String id,
      String categoryId,
      String departmentCode,
      String departmentName,
      String coverUrl,
      String? description,
      int priority});
}

/// @nodoc
class _$CategoryDepartmentCoverCopyWithImpl<$Res,
        $Val extends CategoryDepartmentCover>
    implements $CategoryDepartmentCoverCopyWith<$Res> {
  _$CategoryDepartmentCoverCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryDepartmentCover
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? departmentCode = null,
    Object? departmentName = null,
    Object? coverUrl = null,
    Object? description = freezed,
    Object? priority = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      departmentCode: null == departmentCode
          ? _value.departmentCode
          : departmentCode // ignore: cast_nullable_to_non_nullable
              as String,
      departmentName: null == departmentName
          ? _value.departmentName
          : departmentName // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: null == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryDepartmentCoverImplCopyWith<$Res>
    implements $CategoryDepartmentCoverCopyWith<$Res> {
  factory _$$CategoryDepartmentCoverImplCopyWith(
          _$CategoryDepartmentCoverImpl value,
          $Res Function(_$CategoryDepartmentCoverImpl) then) =
      __$$CategoryDepartmentCoverImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String categoryId,
      String departmentCode,
      String departmentName,
      String coverUrl,
      String? description,
      int priority});
}

/// @nodoc
class __$$CategoryDepartmentCoverImplCopyWithImpl<$Res>
    extends _$CategoryDepartmentCoverCopyWithImpl<$Res,
        _$CategoryDepartmentCoverImpl>
    implements _$$CategoryDepartmentCoverImplCopyWith<$Res> {
  __$$CategoryDepartmentCoverImplCopyWithImpl(
      _$CategoryDepartmentCoverImpl _value,
      $Res Function(_$CategoryDepartmentCoverImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryDepartmentCover
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? departmentCode = null,
    Object? departmentName = null,
    Object? coverUrl = null,
    Object? description = freezed,
    Object? priority = null,
  }) {
    return _then(_$CategoryDepartmentCoverImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      departmentCode: null == departmentCode
          ? _value.departmentCode
          : departmentCode // ignore: cast_nullable_to_non_nullable
              as String,
      departmentName: null == departmentName
          ? _value.departmentName
          : departmentName // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: null == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryDepartmentCoverImpl implements _CategoryDepartmentCover {
  const _$CategoryDepartmentCoverImpl(
      {required this.id,
      required this.categoryId,
      required this.departmentCode,
      required this.departmentName,
      required this.coverUrl,
      this.description,
      this.priority = 10});

  factory _$CategoryDepartmentCoverImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryDepartmentCoverImplFromJson(json);

  @override
  final String id;
  @override
  final String categoryId;
  @override
  final String departmentCode;
  @override
  final String departmentName;
  @override
  final String coverUrl;
  @override
  final String? description;
// Nouveau champ pour la description
  @override
  @JsonKey()
  final int priority;

  @override
  String toString() {
    return 'CategoryDepartmentCover(id: $id, categoryId: $categoryId, departmentCode: $departmentCode, departmentName: $departmentName, coverUrl: $coverUrl, description: $description, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryDepartmentCoverImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.departmentCode, departmentCode) ||
                other.departmentCode == departmentCode) &&
            (identical(other.departmentName, departmentName) ||
                other.departmentName == departmentName) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, categoryId, departmentCode,
      departmentName, coverUrl, description, priority);

  /// Create a copy of CategoryDepartmentCover
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryDepartmentCoverImplCopyWith<_$CategoryDepartmentCoverImpl>
      get copyWith => __$$CategoryDepartmentCoverImplCopyWithImpl<
          _$CategoryDepartmentCoverImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryDepartmentCoverImplToJson(
      this,
    );
  }
}

abstract class _CategoryDepartmentCover implements CategoryDepartmentCover {
  const factory _CategoryDepartmentCover(
      {required final String id,
      required final String categoryId,
      required final String departmentCode,
      required final String departmentName,
      required final String coverUrl,
      final String? description,
      final int priority}) = _$CategoryDepartmentCoverImpl;

  factory _CategoryDepartmentCover.fromJson(Map<String, dynamic> json) =
      _$CategoryDepartmentCoverImpl.fromJson;

  @override
  String get id;
  @override
  String get categoryId;
  @override
  String get departmentCode;
  @override
  String get departmentName;
  @override
  String get coverUrl;
  @override
  String? get description; // Nouveau champ pour la description
  @override
  int get priority;

  /// Create a copy of CategoryDepartmentCover
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryDepartmentCoverImplCopyWith<_$CategoryDepartmentCoverImpl>
      get copyWith => throw _privateConstructorUsedError;
}
