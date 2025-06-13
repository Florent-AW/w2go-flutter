// lib/core/domain/ports/providers/config/sections_discovery_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../adapters/supabase/search/config/sections_discovery_adapter.dart';
import '../../search/config/sections_discovery_port.dart';

/// Provider pour le service de découverte des sections
final sectionsDiscoveryProvider = Provider<SectionsDiscoveryPort>((ref) {
  final client = Supabase.instance.client;
  return SectionsDiscoveryAdapter(client);
});