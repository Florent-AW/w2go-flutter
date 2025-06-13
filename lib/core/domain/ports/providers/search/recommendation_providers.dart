// lib/core/domain/ports/providers/search/recommendation_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../adapters/supabase/search/recommendation_adapter.dart';
import '../../../../adapters/supabase/cache/supabase_cache_adapter.dart';
import '../../search/recommendation_port.dart';

/// Provider pour l'adapter de cache Supabase
final supabaseCacheAdapterProvider = Provider<SupabaseCacheAdapter>((ref) {
  final client = Supabase.instance.client;
  return SupabaseCacheAdapter(client);
});

/// Provider pour l'adapter de recommandations avec cache intégré
final recommendationAdapterProvider = Provider<RecommendationPort>((ref) {
  final client = Supabase.instance.client;
  return RecommendationAdapter(client);
});