// lib/core/application/pagination_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../domain/pagination/paginated_data_provider.dart';
import '../domain/pagination/paginated_result.dart';

part 'pagination_controller.freezed.dart';

/// État de pagination unifié pour tous les carrousels
@freezed
class PaginationState<T> with _$PaginationState<T> {
  const factory PaginationState({
    /// Items chargés (accumulation de toutes les pages)
    @Default([]) List<T> items,
    /// Chargement initial en cours
    @Default(false) bool isLoading,
    /// Chargement de la page suivante en cours
    @Default(false) bool isLoadingMore,
    /// Y a-t-il plus de pages à charger ?
    @Default(true) bool hasMore,
    /// Offset actuel pour la prochaine page
    @Default(0) int currentOffset,
    /// Erreur éventuelle
    String? error,
    /// Indique si les données actuelles sont partielles (preload)
    @Default(false) bool isPartial,
  }) = _PaginationState<T>;
}

/// Controller de pagination unifié
class PaginationController<T> extends StateNotifier<PaginationState<T>> {
  final PaginatedDataProvider<T> _provider;

  PaginationController(this._provider)
      : super(PaginationState<T>(items: <T>[]));

  /// Charge la première page (reset complet)
  Future<void> loadInitial() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _provider.loadPage(
        offset: 0,
        limit: _provider.defaultPageSize,
      );

      state = state.copyWith(
        isLoading: false,
        items: result.items,
        hasMore: result.hasMore,
        currentOffset: result.nextOffset,
        isPartial: false,
      );

      print('✅ PAGINATION: ${_provider.providerId} → ${result.items.length} items initiaux');

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      print('❌ PAGINATION: Erreur ${_provider.providerId}: $e');
    }
  }

  /// Charge la première page avec taille preload (T0)
  Future<void> loadPreload() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _provider.loadPage(
        offset: 0,
        limit: _provider.preloadPageSize,
      );

      state = state.copyWith(
        isLoading: false,
        items: result.items,
        hasMore: result.hasMore,
        currentOffset: result.nextOffset,
        isPartial: true, // ✅ Marquer comme partiel
      );

      print('✅ PAGINATION PRELOAD: ${_provider.providerId} → ${result.items.length} items (preload)');

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      print('❌ PAGINATION PRELOAD: Erreur ${_provider.providerId}: $e');
    }
  }

  /// Charge la page suivante (append)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final result = await _provider.loadPage(
        offset: state.currentOffset,
        limit: _provider.defaultPageSize,
      );

      state = state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...result.items],
        hasMore: result.hasMore,
        currentOffset: result.nextOffset,
        isPartial: false, // ✅ Plus partiel après loadMore
      );

      print('✅ PAGINATION MORE: ${_provider.providerId} → +${result.items.length} items (total: ${state.items.length})');

    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
      print('❌ PAGINATION MORE: Erreur ${_provider.providerId}: $e');
    }
  }

  /// Complétion T1 : charge jusqu'à la taille normale si actuellement partiel
  Future<void> completeIfPartial() async {
    if (!state.isPartial || state.isLoading || state.isLoadingMore) return;

    print('🔄 COMPLETION T1: ${_provider.providerId} → Complétion depuis ${state.items.length} items');

    // Utiliser loadMore pour compléter
    await loadMore();
  }

  /// Reset complet
  void reset() {
    state = PaginationState<T>(items: <T>[]);
  }
}