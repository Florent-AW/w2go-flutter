// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PaginationState<T> {
  /// Items chargés (accumulation de toutes les pages)
  List<T> get items => throw _privateConstructorUsedError;

  /// Chargement initial en cours
  bool get isLoading => throw _privateConstructorUsedError;

  /// Chargement de la page suivante en cours
  bool get isLoadingMore => throw _privateConstructorUsedError;

  /// Y a-t-il plus de pages à charger ?
  bool get hasMore => throw _privateConstructorUsedError;

  /// Offset actuel pour la prochaine page
  int get currentOffset => throw _privateConstructorUsedError;

  /// Erreur éventuelle
  String? get error => throw _privateConstructorUsedError;

  /// Indique si les données actuelles sont partielles (preload)
  bool get isPartial => throw _privateConstructorUsedError;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationStateCopyWith<T, PaginationState<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationStateCopyWith<T, $Res> {
  factory $PaginationStateCopyWith(
          PaginationState<T> value, $Res Function(PaginationState<T>) then) =
      _$PaginationStateCopyWithImpl<T, $Res, PaginationState<T>>;
  @useResult
  $Res call(
      {List<T> items,
      bool isLoading,
      bool isLoadingMore,
      bool hasMore,
      int currentOffset,
      String? error,
      bool isPartial});
}

/// @nodoc
class _$PaginationStateCopyWithImpl<T, $Res, $Val extends PaginationState<T>>
    implements $PaginationStateCopyWith<T, $Res> {
  _$PaginationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? hasMore = null,
    Object? currentOffset = null,
    Object? error = freezed,
    Object? isPartial = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentOffset: null == currentOffset
          ? _value.currentOffset
          : currentOffset // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isPartial: null == isPartial
          ? _value.isPartial
          : isPartial // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginationStateImplCopyWith<T, $Res>
    implements $PaginationStateCopyWith<T, $Res> {
  factory _$$PaginationStateImplCopyWith(_$PaginationStateImpl<T> value,
          $Res Function(_$PaginationStateImpl<T>) then) =
      __$$PaginationStateImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {List<T> items,
      bool isLoading,
      bool isLoadingMore,
      bool hasMore,
      int currentOffset,
      String? error,
      bool isPartial});
}

/// @nodoc
class __$$PaginationStateImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$PaginationStateImpl<T>>
    implements _$$PaginationStateImplCopyWith<T, $Res> {
  __$$PaginationStateImplCopyWithImpl(_$PaginationStateImpl<T> _value,
      $Res Function(_$PaginationStateImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? hasMore = null,
    Object? currentOffset = null,
    Object? error = freezed,
    Object? isPartial = null,
  }) {
    return _then(_$PaginationStateImpl<T>(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentOffset: null == currentOffset
          ? _value.currentOffset
          : currentOffset // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isPartial: null == isPartial
          ? _value.isPartial
          : isPartial // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PaginationStateImpl<T> implements _PaginationState<T> {
  const _$PaginationStateImpl(
      {final List<T> items = const [],
      this.isLoading = false,
      this.isLoadingMore = false,
      this.hasMore = true,
      this.currentOffset = 0,
      this.error,
      this.isPartial = false})
      : _items = items;

  /// Items chargés (accumulation de toutes les pages)
  final List<T> _items;

  /// Items chargés (accumulation de toutes les pages)
  @override
  @JsonKey()
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Chargement initial en cours
  @override
  @JsonKey()
  final bool isLoading;

  /// Chargement de la page suivante en cours
  @override
  @JsonKey()
  final bool isLoadingMore;

  /// Y a-t-il plus de pages à charger ?
  @override
  @JsonKey()
  final bool hasMore;

  /// Offset actuel pour la prochaine page
  @override
  @JsonKey()
  final int currentOffset;

  /// Erreur éventuelle
  @override
  final String? error;

  /// Indique si les données actuelles sont partielles (preload)
  @override
  @JsonKey()
  final bool isPartial;

  @override
  String toString() {
    return 'PaginationState<$T>(items: $items, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasMore: $hasMore, currentOffset: $currentOffset, error: $error, isPartial: $isPartial)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationStateImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.currentOffset, currentOffset) ||
                other.currentOffset == currentOffset) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isPartial, isPartial) ||
                other.isPartial == isPartial));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      isLoading,
      isLoadingMore,
      hasMore,
      currentOffset,
      error,
      isPartial);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationStateImplCopyWith<T, _$PaginationStateImpl<T>> get copyWith =>
      __$$PaginationStateImplCopyWithImpl<T, _$PaginationStateImpl<T>>(
          this, _$identity);
}

abstract class _PaginationState<T> implements PaginationState<T> {
  const factory _PaginationState(
      {final List<T> items,
      final bool isLoading,
      final bool isLoadingMore,
      final bool hasMore,
      final int currentOffset,
      final String? error,
      final bool isPartial}) = _$PaginationStateImpl<T>;

  /// Items chargés (accumulation de toutes les pages)
  @override
  List<T> get items;

  /// Chargement initial en cours
  @override
  bool get isLoading;

  /// Chargement de la page suivante en cours
  @override
  bool get isLoadingMore;

  /// Y a-t-il plus de pages à charger ?
  @override
  bool get hasMore;

  /// Offset actuel pour la prochaine page
  @override
  int get currentOffset;

  /// Erreur éventuelle
  @override
  String? get error;

  /// Indique si les données actuelles sont partielles (preload)
  @override
  bool get isPartial;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationStateImplCopyWith<T, _$PaginationStateImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
