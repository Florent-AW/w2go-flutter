// lib/core/domain/ports/providers/search/category_search_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../ports/search/category_search_port.dart';
import '../../../../adapters/supabase/search/category_search_adapter.dart';

final categorySearchProvider = Provider<CategorySearchPort>((ref) {
  final client = Supabase.instance.client;
  return CategorySearchAdapter(client);
});