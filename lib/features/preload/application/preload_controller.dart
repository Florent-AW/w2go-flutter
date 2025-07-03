import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/shared/city_model.dart';
import '../../../core/domain/models/shared/category_model.dart';
import '../../../core/domain/models/shared/experience_item.dart';
import '../../city_page/application/providers/city_experiences_controller.dart';
import '../../city_page/application/providers/city_experiences_controller.dart';
import '../../categories/application/state/categories_provider.dart';

enum PreloadState { idle, loading, ready }

class PreloadData {
  final PreloadState state;
  final String? error;
  final List<String> criticalImageUrls;
  final List<CarouselLoadInfo> carouselsInfo;

  const PreloadData({
    required this.state,
    this.error,
    this.criticalImageUrls = const [],
    this.carouselsInfo = const [],
  });

  PreloadData copyWith({
    PreloadState? state,
    String? error,
    List<String>? criticalImageUrls,
    List<CarouselLoadInfo>? carouselsInfo,
  }) {
    return PreloadData(
      state: state ?? this.state,
      error: error ?? this.error,
      criticalImageUrls: criticalImageUrls ?? this.criticalImageUrls,
      carouselsInfo: carouselsInfo ?? this.carouselsInfo,
    );
  }
}

class CarouselLoadInfo {
  final String categoryId;
  final String sectionId;
  final String title;
  final int loadedItems;
  final bool isPartial;
  final int totalAvailable;

  const CarouselLoadInfo({
    required this.categoryId,
    required this.sectionId,
    required this.title,
    required this.loadedItems,
    required this.isPartial,
    required this.totalAvailable,
  });
}

class PreloadController extends StateNotifier<PreloadData> {
  final Ref ref;

  PreloadController(this.ref) : super(const PreloadData(state: PreloadState.idle));

  /// Démarre le préchargement pour une ville et page cible
  Future<void> startPreload(City city, String targetPageType) async {
    print('🚀 PRELOAD: Démarrage pour ${city.cityName}, page: $targetPageType');

    state = state.copyWith(state: PreloadState.loading);

    try {
      // Pour l'instant, on ne gère que CityPage
      if (targetPageType == 'city') {
        await _preloadCityPage(city);
      }
      // TODO: Ajouter CategoryPage plus tard

      state = state.copyWith(state: PreloadState.ready);
      print('✅ PRELOAD: Terminé avec succès');

    } catch (e) {
      print('❌ PRELOAD: Erreur: $e');
      state = state.copyWith(
        state: PreloadState.ready, // On continue quand même
        error: e.toString(),
      );
    }
  }

  /// Précharge les données d'une CityPage avec logique différentielle
  Future<void> _preloadCityPage(City city) async {
    try {
      // 1. Récupérer les catégories pour connaître la structure
      final allCategories = await ref.read(categoriesProvider.future);
      if (allCategories.isEmpty) {
        throw Exception('Aucune catégorie disponible');
      }

      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';

      // Séparer événements et activités
      final activityCategories = allCategories
          .where((cat) => cat.id != eventsCategoryId)
          .take(6)
          .toList();

      final eventCategory = allCategories.where((cat) => cat.id == eventsCategoryId).isNotEmpty
          ? allCategories.firstWhere((cat) => cat.id == eventsCategoryId)
          : Category(id: eventsCategoryId, name: 'Événements');

      // 2. Charger avec limites différentielles
      final carouselsInfo = <CarouselLoadInfo>[];
      final imageUrls = <String>[];

      // Événements (carrousel 1) - 10 items
      await _loadCarouselWithLimit(
          city, eventCategory, '7f94df23-ab30-4bf3-afb2-59320e5466a7',
          10, carouselsInfo, imageUrls, isFirst: true
      );

      // Activités (carrousels 2-7)
      for (int i = 0; i < activityCategories.length; i++) {
        final category = activityCategories[i];
        final limit = i == 0 ? 10 : 5; // Carrousel 2: 10 items, autres: 5 items

        await _loadCarouselWithLimit(
            city, category, '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f',
            limit, carouselsInfo, imageUrls, isFirst: i == 0
        );
      }

      // 3. Mettre à jour le state
      state = state.copyWith(
        criticalImageUrls: imageUrls,
        carouselsInfo: carouselsInfo,
      );

      print('✅ PRELOAD: ${carouselsInfo.length} carrousels, ${imageUrls.length} images');

    } catch (e) {
      print('❌ PRELOAD: Erreur _preloadCityPage: $e');
      rethrow;
    }
  }

  /// Helper pour charger un carrousel avec limite spécifique
  Future<void> _loadCarouselWithLimit(
      City city,
      Category category,
      String sectionId,
      int limit,
      List<CarouselLoadInfo> carouselsInfo,
      List<String> imageUrls,
      {required bool isFirst}
      ) async {
    try {
      // Utiliser les méthodes publiques du CityExperiencesController
      final controllerInstance = ref.read(cityExperiencesControllerInstanceProvider(city.id));

      CategoryExperiences categoryExperiences;

      if (category.id == 'c3b42899-fdc3-48f7-bd85-09be3381aba9') {
        // Événements
        categoryExperiences = await controllerInstance.loadEventsCategoryWithLimit(
            category,
            city,
            limit
        );
      } else {
        // Activités
        categoryExperiences = await controllerInstance.loadActivityCategoryWithLimit(
            category,
            city,
            limit
        );
      }

      // Extraire les expériences de la première section
      final experiences = categoryExperiences.sections.isNotEmpty
          ? categoryExperiences.sections.first.experiences
          : <ExperienceItem>[];

      // Collecter les URLs d'images
      for (final exp in experiences) {
        if (exp.mainImageUrl?.isNotEmpty == true) {
          imageUrls.add(exp.mainImageUrl!);
        }
      }

      // Ajouter les infos du carrousel
      carouselsInfo.add(CarouselLoadInfo(
        categoryId: category.id,
        sectionId: sectionId,
        title: category.name,
        loadedItems: experiences.length,
        isPartial: limit == 5 && experiences.length >= 5,
        totalAvailable: 30, // Estimation
      ));

      print('✅ PRELOAD: ${category.name} → ${experiences.length} items (limit: $limit)');

    } catch (e) {
      print('❌ PRELOAD: Erreur ${category.name}: $e');
      // Ajouter une info vide en cas d'erreur
      carouselsInfo.add(CarouselLoadInfo(
        categoryId: category.id,
        sectionId: sectionId,
        title: category.name,
        loadedItems: 0,
        isPartial: false,
        totalAvailable: 0,
      ));
    }
  }

  /// Reset l'état
  void reset() {
    state = const PreloadData(state: PreloadState.idle);
  }
}