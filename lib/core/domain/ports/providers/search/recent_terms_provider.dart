// core/domain/ports/providers/search/recent_terms_provider.dart

import 'package:riverpod/riverpod.dart';
import '../../../../adapters/cache/hive_recent_terms_adapter.dart';
import '../../search/recent_terms_port.dart';

final recentTermsPortProvider = Provider<RecentTermsPort>((ref) {
  final adapter = HiveRecentTermsAdapter();
  // Fire and forget init; Hive was already initialized in main
  adapter.initializeAsync();
  return adapter;
});
