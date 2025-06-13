// lib/core/domain/ports/providers/search/activity_search_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../adapters/supabase/search/activity_search_adapter.dart';
import '../../../ports/search/activity_search_port.dart';

/// Provider pour l'accès à la fonctionnalité de recherche d'activités
final activitySearchProvider = Provider<ActivitySearchPort>((ref) {
  final client = Supabase.instance.client;
  return ActivitySearchAdapter(client);
});