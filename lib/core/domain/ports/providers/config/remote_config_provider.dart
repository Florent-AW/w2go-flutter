// lib/core/domain/ports/providers/config/remote_config_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../adapters/supabase/config/remote_config_adapter.dart';
import '../../../../domain/models/config/home_section_config.dart';
import '../../../../adapters/supabase/database_adapter.dart';
import '../../../../domain/models/config/subcategory_section_config.dart';


final remoteConfigProvider = Provider((ref) =>
    SupabaseRemoteConfigAdapter(SupabaseService.client)
);

final homeSectionsConfigProvider = FutureProvider<List<HomeSectionConfig>>((ref) async {
  print('📥 Starting to fetch home sections');
  try {
    final configAdapter = ref.watch(remoteConfigProvider);
    print('📦 Got config adapter');
    final sections = await configAdapter.getHomeSections();
    print('📋 Fetched sections: $sections');
    return sections;
  } catch (e) {
    print('❌ Error fetching sections: $e');
    rethrow;
  }
});

final subcategorySectionsConfigProvider =
FutureProvider.family<List<SubcategorySectionConfig>, String?>((ref, subcategoryId) async {
  print('📥 Starting to fetch subcategory sections for id: $subcategoryId');
  try {
    final configAdapter = ref.watch(remoteConfigProvider);
    print('📦 Got config adapter');
    final sections = await configAdapter.getSubcategorySections(subcategoryId);
    print('📋 Fetched subcategory sections: $sections');
    return sections;
  } catch (e) {
    print('❌ Error fetching subcategory sections: $e');
    rethrow;
  }
});