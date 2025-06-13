// lib/core/domain/ports/providers/empty_trips/neighbor_geohashes.provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../services/designer/empty_trips/neighbor_geohashes.service.dart';

final neighborGeohashesProvider = Provider<NeighborGeohashesService>((ref) {
  final supabase = Supabase.instance.client;
  return NeighborGeohashesService(supabase);
});