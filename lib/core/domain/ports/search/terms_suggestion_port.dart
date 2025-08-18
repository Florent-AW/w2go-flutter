// core/domain/ports/search/terms_suggestion_port.dart

import '../../models/search/term_suggestion.dart';

abstract class TermsSuggestionPort {
  Future<List<TermSuggestion>> suggest(
    String prefix, {
    required double lat,
    required double lon,
    double radiusKm = 50,
    String lang = 'fr',
    int limit = 10,
  });
}
