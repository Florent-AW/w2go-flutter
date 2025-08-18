// features/terms_search/application/terms_search_notifier.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/models/search/term_suggestion.dart';
import '../../../core/domain/ports/providers/search/terms_suggestion_providers.dart';
import '../../search/application/state/city_selection_state.dart';
import '../../../core/domain/ports/providers/search/recent_terms_provider.dart';

enum TermsSearchStatus { idle, loading, success, empty, error }

class TermsSearchState {
  final String query;
  final TermsSearchStatus status;
  final List<TermSuggestion> items;
  final String? error;
  final List<String> recentTerms;

  const TermsSearchState({
    this.query = '',
    this.status = TermsSearchStatus.idle,
    this.items = const [],
    this.error,
    this.recentTerms = const [],
  });

  TermsSearchState copyWith({
    String? query,
    TermsSearchStatus? status,
    List<TermSuggestion>? items,
    String? error,
    List<String>? recentTerms,
  }) => TermsSearchState(
        query: query ?? this.query,
        status: status ?? this.status,
        items: items ?? this.items,
        error: error,
        recentTerms: recentTerms ?? this.recentTerms,
      );
}

class TermsSearchNotifier extends StateNotifier<TermsSearchState> {
  final Ref _ref;
  Timer? _debounce;

  TermsSearchNotifier(this._ref) : super(const TermsSearchState()) {
    _loadRecent();
  }

  static const int minChars = 2;
  static const int limit = 10;
  static const double defaultRadiusKm = 50;

  void onQueryChanged(String q) {
    state = state.copyWith(query: q);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _searchIfNeeded);
  }

  Future<void> _loadRecent() async {
    final recent = await _ref.read(recentTermsPortProvider).getRecentTerms(limit: 8);
    state = state.copyWith(recentTerms: recent);
  }

  Future<void> _searchIfNeeded() async {
    final q = state.query.trim();
    if (q.length < minChars) {
      state = state.copyWith(status: TermsSearchStatus.idle, items: const []);
      return;
    }
    await _performSearch(q);
  }

  Future<void> _performSearch(String q) async {
    final city = _ref.read(selectedCityProvider);
    if (city == null) {
      state = state.copyWith(status: TermsSearchStatus.error, error: 'Ville requise');
      return;
    }

    state = state.copyWith(status: TermsSearchStatus.loading, error: null);
    try {
      final port = _ref.read(termsSuggestionPortProvider);
      final list = await port.suggest(q,
          lat: city.lat, lon: city.lon, radiusKm: defaultRadiusKm, lang: 'fr', limit: limit);
      // Guard against stale results: only apply if the query did not change
      if (state.query.trim() == q.trim()) {
        state = state.copyWith(
          status: list.isEmpty ? TermsSearchStatus.empty : TermsSearchStatus.success,
          items: list,
        );
      }
    } catch (e) {
      state = state.copyWith(status: TermsSearchStatus.error, error: e.toString());
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> onSuggestionTapped(TermSuggestion s) async {
    // Save recent term
    await _ref.read(recentTermsPortProvider).addRecentTerm(s.term, maxEntries: 8);
  }
}

final termsSearchNotifierProvider = StateNotifierProvider<TermsSearchNotifier, TermsSearchState>((ref) {
  return TermsSearchNotifier(ref);
});
