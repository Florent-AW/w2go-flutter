// lib/core/domain/ports/providers/search/subcategory_search_provider.dart


import 'package:riverpod/riverpod.dart';
import '../../search/subcategory_search_port.dart';
import '../../../models/shared/subcategory_model.dart';
import '../../../../adapters/supabase/search/subcategory_search_adapter.dart';
import '../../../../adapters/supabase/database_adapter.dart';

final subcategorySearchProvider = Provider<SubcategorySearchPort>((ref) {
  return SubcategorySearchAdapter(SupabaseService.client);
});

final subcategoriesProvider = FutureProvider<List<Subcategory>>((ref) async {
  final subcategorySearchPort = ref.read(subcategorySearchProvider);
  return subcategorySearchPort.getSubcategoriesForSearch();
});