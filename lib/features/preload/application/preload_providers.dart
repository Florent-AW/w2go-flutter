// lib/features/preload/application/preload_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'preload_controller.dart';

final preloadControllerProvider = StateNotifierProvider<PreloadController, PreloadData>((ref) {
  return PreloadController(ref);
});