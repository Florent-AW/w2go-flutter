// features/terms_search/application/terms_results_notifier.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../search/application/state/city_selection_state.dart';
import '../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../core/domain/models/search/concept_types.dart';
import '../../../core/domain/pagination/paginated_result.dart';
import '../../../core/domain/ports/providers/search/activities_by_concept_provider.dart';

enum TermsResultsStatus { idle, loading, success, empty, error }

typedef TermsResultsArgs = ({String conceptId, ConceptType conceptType, String title, double radiusKm});

class TermsResultsState {
  final TermsResultsStatus status;
  final List<SearchableActivity> items;
  final int totalCount;
  final bool hasMore;
  final int nextOffset;
  final SortMode sort;
  final String? error;

  const TermsResultsState({
    this.status = TermsResultsStatus.idle,
    this.items = const [],
    this.totalCount = 0,
    this.hasMore = false,
    this.nextOffset = 0,
    this.sort = SortMode.distance,
    this.error,
  });

  TermsResultsState copyWith({
    TermsResultsStatus? status,
    List<SearchableActivity>? items,
    int? totalCount,
    bool? hasMore,
    int? nextOffset,
    SortMode? sort,
    String? error,
  }) => TermsResultsState(
        status: status ?? this.status,
        items: items ?? this.items,
        totalCount: totalCount ?? this.totalCount,
        hasMore: hasMore ?? this.hasMore,
        nextOffset: nextOffset ?? this.nextOffset,
        sort: sort ?? this.sort,
        error: error,
      );
}

class TermsResultsNotifier extends StateNotifier<TermsResultsState> {
  final Ref _ref;
  int _requestId = 0;
  TermsResultsArgs? _args;
  bool _isLoadingMore = false;

  TermsResultsNotifier(this._ref) : super(const TermsResultsState());

  void initialize(TermsResultsArgs args) {
    _args = args;
    _requestId++;
    _fetch(reset: true, requestId: _requestId);
  }

  Future<void> refresh() async {
    if (_args == null) return;
    _requestId++;
    await _fetch(reset: true, requestId: _requestId);
  }

  Future<void> loadMore() async {
    if (_args == null || state.status == TermsResultsStatus.loading || _isLoadingMore || !state.hasMore) return;
    _isLoadingMore = true;
    final req = ++_requestId;
    await _fetch(reset: false, requestId: req);
    _isLoadingMore = false;
  }

  Future<void> _fetch({required bool reset, required int requestId}) async {
    final args = _args;
    if (args == null) return;

    final city = _ref.read(selectedCityProvider);
    if (city == null) {
      state = state.copyWith(status: TermsResultsStatus.error, error: 'Ville requise');
      return;
    }

    if (reset) {
      state = state.copyWith(status: TermsResultsStatus.loading, items: [], nextOffset: 0, totalCount: 0, hasMore: false, error: null);
    }

    try {
      final port = _ref.read(activitiesByConceptPortProvider);
      final page = await port.list(
        conceptId: args.conceptId,
        conceptType: args.conceptType,
        lat: city.lat,
        lon: city.lon,
        radiusKm: args.radiusKm,
        sort: state.sort,
        limit: 20,
        offset: reset ? 0 : state.nextOffset,
      );

      if (_requestId != requestId) return; // anti-stale

      final items = reset ? page.items : [...state.items, ...page.items];
      final status = (items.isEmpty) ? TermsResultsStatus.empty : TermsResultsStatus.success;
      state = state.copyWith(
        status: status,
        items: items,
        totalCount: page.totalCount ?? items.length,
        hasMore: page.hasMore,
        nextOffset: page.nextOffset,
      );
    } catch (e) {
      if (_requestId != requestId) return;
      state = state.copyWith(status: TermsResultsStatus.error, error: e.toString());
    }
  }
}

final termsResultsNotifierProvider = StateNotifierProvider.autoDispose<TermsResultsNotifier, TermsResultsState>((ref) {
  return TermsResultsNotifier(ref);
});
