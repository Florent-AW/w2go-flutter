// core/domain/ports/providers/search/terms_suggestion_providers.dart

import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../search/terms_suggestion_port.dart';
import '../../../../adapters/supabase/search/terms_suggestion_adapter.dart';

/// Provider to access the TermsSuggestionPort implementation.
final termsSuggestionPortProvider = Provider<TermsSuggestionPort>((ref) {
  final client = Supabase.instance.client;
  return TermsSuggestionAdapter(client);
});
