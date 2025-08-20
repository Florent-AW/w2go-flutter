// features/terms_search/application/terms_results_sections_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../search/application/state/city_selection_state.dart';
import '../../../core/domain/models/search/result_section.dart';
import '../../../core/domain/models/search/concept_types.dart';
import '../../../core/domain/ports/providers/search/activities_by_concept_sections_provider.dart';
import '../../../core/domain/ports/providers/repositories/repository_providers.dart';

enum TermsResultsSectionsStatus { idle, loading, success, empty, error }

typedef TermsResultsSectionsArgs = ({String conceptId, ConceptType conceptType, String title});

class TermsResultsSectionsState {
  final TermsResultsSectionsStatus status;
  final List<ResultSection> sections;
  final String? error;

  const TermsResultsSectionsState({
    this.status = TermsResultsSectionsStatus.idle,
    this.sections = const [],
    this.error,
  });

  TermsResultsSectionsState copyWith({
    TermsResultsSectionsStatus? status,
    List<ResultSection>? sections,
    String? error,
  }) => TermsResultsSectionsState(
        status: status ?? this.status,
        sections: sections ?? this.sections,
        error: error,
      );
}

class TermsResultsSectionsNotifier extends StateNotifier<TermsResultsSectionsState> {
  final Ref _ref;
  int _requestId = 0;
  TermsResultsSectionsArgs? _args;

  TermsResultsSectionsNotifier(this._ref) : super(const TermsResultsSectionsState());

  void initialize(TermsResultsSectionsArgs args) {
    _args = args;
    _requestId++;
    _fetch(requestId: _requestId);
  }

  Future<void> refresh() async {
    if (_args == null) return;
    _requestId++;
    await _fetch(requestId: _requestId);
  }

  Future<void> _fetch({required int requestId}) async {
    final args = _args;
    if (args == null) return;

    final city = _ref.read(selectedCityProvider);
    if (city == null) {
      state = state.copyWith(status: TermsResultsSectionsStatus.error, error: 'Ville requise');
      return;
    }

    state = state.copyWith(status: TermsResultsSectionsStatus.loading, error: null);

    try {
      final port = _ref.read(activitiesByConceptSectionsPortProvider);
      final sections = await port.fetchSections(
        conceptId: args.conceptId,
        conceptType: args.conceptType,
        lat: city.lat,
        lon: city.lon,
      );

      if (_requestId != requestId) return; // anti-stale

      state = state.copyWith(
        status: sections.isEmpty ? TermsResultsSectionsStatus.empty : TermsResultsSectionsStatus.success,
        sections: sections,
      );

      // Write to search history after success
      if (sections.isNotEmpty) {
        final history = _ref.read(searchHistoryRepositoryProvider);
        await history.addTermsExecution(
          conceptId: args.conceptId,
          conceptType: args.conceptType.asParam,
          termTitle: args.title,
          cityId: null,
          cityName: city.cityName,
          lat: city.lat,
          lon: city.lon,
        );
      }
    } catch (e) {
      if (_requestId != requestId) return;
      state = state.copyWith(status: TermsResultsSectionsStatus.error, error: e.toString());
    }
  }
}

final termsResultsSectionsNotifierProvider = StateNotifierProvider.autoDispose<TermsResultsSectionsNotifier, TermsResultsSectionsState>((ref) {
  return TermsResultsSectionsNotifier(ref);
});
