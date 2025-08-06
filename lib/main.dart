import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // Pour kDebugMode
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/rendering.dart';  // Pour debugPrintMarkNeedsPaintStacks, debugProfileBuildsEnabled
import 'package:animations/animations.dart'; // ✅ EXPERT 2025 : Material You Motion

import '/core/adapters/supabase/database_adapter.dart';
import 'core/adapters/cache/hive_adapters.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';
import '../core/domain/ports/providers/empty_trips/google_services_config.provider.dart';
import '../core/domain/services/google_services_config.dart';
import 'core/adapters/cache/hive_recent_cities_adapter.dart';
import 'core/adapters/supabase/search/suggested_cities_adapter.dart';
import 'core/domain/ports/providers/search/recent_cities_provider.dart';
import 'core/domain/ports/providers/search/suggested_cities_provider.dart';
import '../core/adapters/cache/hive_location_cache_adapter.dart';

import 'routes/app_router.dart';
import 'routes/flow_manager.dart';
import 'routes/route_names.dart';
import 'features/search/application/state/city_selection_state.dart';
import 'core/domain/models/shared/city_model.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // ✅ CONFIGURATION UNIQUE ImageCache (évite conflits)
    _configureImageCache();

        await dotenv.load(fileName: ".env");

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await initializeDateFormatting('fr_FR', null);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(userLocationTypeId)) {
      Hive.registerAdapter(UserLocationAdapter());
    }
    if (!Hive.isAdapterRegistered(placeDetailsTypeId)) {
      Hive.registerAdapter(PlaceDetailsAdapter());
    }
    if (!Hive.isAdapterRegistered(placeSuggestionTypeId)) {
      Hive.registerAdapter(PlaceSuggestionAdapter());
    }

    final cacheAdapter = HiveLocationCacheAdapter();
    await cacheAdapter.initializeAsync();

    await SupabaseService.initialize();
    final googleConfig = await GoogleServicesConfig.init();

    final cityBox = await Hive.openBox('cityPreferences');
    final cityJson = cityBox.get('selectedCity');
    final City? savedCity = cityJson != null
        ? City.fromJson(json.decode(cityJson))
        : null;

    runApp(
      ProviderScope(
        overrides: [
          googleServicesConfigProvider.overrideWithValue(googleConfig),
          if (savedCity != null)
            selectedCityProvider.overrideWith((ref) => CitySelectionNotifier(savedCity)),
          recentCitiesPortProvider.overrideWithProvider(
            Provider((ref) {
              final adapter = HiveRecentCitiesAdapter();
              adapter.initializeAsync();
              return adapter;
            }),
          ),
          suggestedCitiesPortProvider.overrideWithProvider(
            Provider((ref) => SupabaseSuggestedCitiesAdapter.fromService(
                Supabase.instance.client)),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Error initializing app: $e');
  }
}

/// ✅ Configuration centralisée du cache images
void _configureImageCache() {
  final imageCache = PaintingBinding.instance.imageCache;

  // ✅ Valeurs optimisées pour featured précache + navigation fluide
  imageCache.maximumSize = 500; // 500 images en RAM
  imageCache.maximumSizeBytes = 200 << 20; // 200 Mo max

  print('🖼️ IMAGE CACHE CONFIG: ${imageCache.maximumSize} images, ${(imageCache.maximumSizeBytes / (1024 * 1024)).round()} Mo');
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialRoute = FlowManager.getInitialRoute(ref);
    print('🚀 Route initiale: $initialRoute');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(context),
      darkTheme: _buildDarkTheme(context),
      themeMode: ThemeMode.system,

      initialRoute: initialRoute,
      onGenerateRoute: (settings) => AppRouter.generateRoute(settings, ref),
      showPerformanceOverlay: kDebugMode ? false : false,
    );
  }

  /// ✅ EXPERT 2025 : Thème clair avec Material You Motion
  ThemeData _buildLightTheme(BuildContext context) {
    final baseTheme = AppTheme.lightTheme(context);

    return baseTheme.copyWith(
      // ✅ EXPERT 2025 : Material 3 activé
      useMaterial3: true,

      // ✅ EXPERT 2025 : Densité visuelle adaptive pour 120 fps
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // ✅ EXPERT 2025 : Transitions optimisées Material You
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeThroughPageTransitionsBuilder(),
        },
      ),

      // ✅ EXPERT 2025 : Configuration des animations pour 120 fps
      extensions: [
        // Garde vos extensions existantes
        ...baseTheme.extensions.values,

        // ✅ Ajouter des configurations d'animation si nécessaire
      ],
    );
  }

  /// ✅ EXPERT 2025 : Thème sombre avec Material You Motion
  ThemeData _buildDarkTheme(BuildContext context) {
    final baseTheme = AppTheme.darkTheme(context);

    return baseTheme.copyWith(
      // ✅ EXPERT 2025 : Material 3 activé
      useMaterial3: true,

      // ✅ EXPERT 2025 : Densité visuelle adaptive pour 120 fps
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // ✅ EXPERT 2025 : Transitions optimisées Material You
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeThroughPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeThroughPageTransitionsBuilder(),
        },
      ),

      // ✅ EXPERT 2025 : Configuration des animations pour 120 fps
      extensions: [
        // Garde vos extensions existantes
        ...baseTheme.extensions.values,
      ],
    );
  }
}