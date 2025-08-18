// core/adapters/supabase/search/terms_suggestion_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/models/search/term_suggestion.dart';
import '../../../domain/ports/search/terms_suggestion_port.dart';

class TermsSuggestionAdapter implements TermsSuggestionPort {
  final SupabaseClient _client;

  TermsSuggestionAdapter(this._client);

  @override
  Future<List<TermSuggestion>> suggest(
    String prefix, {
    required double lat,
    required double lon,
    double radiusKm = 50,
    String lang = 'fr',
    int limit = 10,
  }) async {
    if (prefix.isEmpty) return const [];

    final response = await _client.rpc('fn_suggest_terms', params: {
      'p_prefix': prefix,
      'p_lat': lat,
      'p_lon': lon,
      'p_radius_km': radiusKm,
      'p_lang': lang,
      'p_limit': limit,
    });

    if (response == null) return const [];
    final list = (response as List).cast<Map<String, dynamic>>();
    return list.map(TermSuggestion.fromSupabase).toList(growable: false);
  }
}
