// lib/features/search/domain/providers/search_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/adapters/supabase/search/activity_search_adapter.dart';
import '../../../../core/domain/ports/search/activity_search_port.dart';
import '../../../../core/domain/use_cases/search/get_activities_use_case.dart';
import '../../../../core/adapters/supabase/database_adapter.dart';

final searchProvidersModule = <Override>[
  // Providers existants
  Provider<ActivitySearchPort>((ref) {
    return ActivitySearchAdapter(SupabaseService.client);
  }),

  Provider<GetActivitiesUseCase>((ref) {
    return GetActivitiesUseCase(ref.watch(
      Provider<ActivitySearchPort>((ref) =>
          ActivitySearchAdapter(SupabaseService.client)
      ),
    ));
  }),
];