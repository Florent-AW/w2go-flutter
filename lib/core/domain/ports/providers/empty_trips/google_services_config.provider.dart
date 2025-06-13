// core/domain/ports/providers/empty_trips/google_services_config.provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/google_services_config.dart';

final googleServicesConfigProvider = Provider<GoogleServicesConfig>((ref) {
  throw UnimplementedError('Doit être surchargé au niveau de l\'app');
});