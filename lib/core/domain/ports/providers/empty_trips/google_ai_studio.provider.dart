// core/domain/ports/providers/empty_trips/google_ai_studio.provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../adapters/google/google_ai_studio_service.dart';
import 'google_services_config.provider.dart';

final googleAIStudioServiceProvider = Provider<GoogleAIStudioService?>((ref) {
  final config = ref.watch(googleServicesConfigProvider);

  try {
    return GoogleAIStudioService(config);
  } catch (e) {
    print('❌ Erreur initialisation Google AI Studio: $e');
    return null;
  }
});