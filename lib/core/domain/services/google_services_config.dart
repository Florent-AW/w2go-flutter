// core/domain/services/google_services_config.dart


import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleServicesConfig {
  final String mapsApiKey;
  final String aiStudioApiKey;

  GoogleServicesConfig._({
    required this.mapsApiKey,
    required this.aiStudioApiKey,
  });

  static Future<GoogleServicesConfig> init() async {
    await dotenv.load();
    return GoogleServicesConfig._(
      mapsApiKey: dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '',
      aiStudioApiKey: dotenv.env['GOOGLE_AI_STUDIO_API_KEY'] ?? '',
    );
  }
}