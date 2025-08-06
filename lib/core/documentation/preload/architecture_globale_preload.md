# 🏗️ **Architecture Globale Preload - Vue d'ensemble système**

## 🎯 **Vision d'ensemble**

Système preload multi-phases pour éliminer tous les temps de chargement et flashs visuels. Architecture modulaire avec orchestration centralisée et fail-safe.

### **Phases temporelles**
- **T0 (0-2.5s)** : Critique - Données essentielles première page
- **T1 (1.5s auto)** : Complétion - Enrichissement automatique contenu
- **T2 (250ms+)** : Warm - Préparation pages suivantes en arrière-plan

---

## 🎭 **Stratégies par page**

### **CityPage (Système unifié v1.1)**
```
T0: 7 carrousels × 5-10 items + 50 images
T1: Auto-complétion 5→25 items par carrousel (1.5s timer)
T2: Lazy loading infini au scroll
```

### **CategoryPage (Système hybride v2.0)**
```
T0: 1ère catégorie (featured + subcategory) + covers autres catégories
T1: Auto-complétion 1ère catégorie (timer existant)
T2: Featured autres catégories (3 items structure) + covers précache
```

### **HomeShell (Orchestrateur central)**
```  
T0: Bootstrap première page + warm headers catégories
T2: Déclenchement warm silencieux après overlay fade-out
```

---

## 🧠 **Composants centraux**

### **`features/preload/application/preload_controller.dart`**
```dart
class PreloadController extends StateNotifier<PreloadData> {
  // ✅ T0 API principale
  Future<void> startPreload(City city, String targetPageType);
  Future<void> startPreloadCategory(City city, String categoryId);
  
  // ✅ T2 API warm silencieux  
  Future<void> warmCategoryHeadersSilently(City city, List<String> categoryIds);
  Future<void> warmFeaturedCarouselsSilently(City city, {String? excludeCategoryId});
  
  // ✅ Storage unifié
  PreloadData state: {
    carouselData: Map<String, List<ExperienceItem>>,
    categoryHeaders: Map<String, CategoryHeader>,
    criticalImageUrls: List<String>,
  }
}
```

### **`features/preload/presentation/loading_route.dart`**
```dart
class LoadingRoute extends ConsumerStatefulWidget {
  // ✅ Orchestration T0 complète
  // 1. startPreload(city, pageType)
  // 2. precacheMultiple(criticalImageUrls)  
  // 3. Navigation automatique quand ready
}
```

### **`features/home/presentation/pages/home_shell.dart`**
```dart
// ✅ Orchestrateur T2 central
void _onPreloadBecameReady() {
  // 1. Fade-out overlay
  Future.delayed(250ms, () {
    // 2. warmCategoryHeadersSilently() 
    // 3. warmFeaturedCarouselsSilently()
  });
}
```

---

## 🔄 **Flow orchestration complète**

### **Navigation CityPicker → CityPage**
```mermaid
User tap ville
    ↓
LoadingRoute + TargetPageService("city")
    ↓
PreloadController.startPreload(city, "city")
    ↓
_preloadCityPage(): 7 carrousels (2×10 + 5×5)
    ↓
CachingImageProvider.precacheMultiple(~50 images)
    ↓ 
Navigation → CityPageTemplate
    ↓
HomeShell._onPreloadBecameReady()
    ↓
warmCategoryHeadersSilently() [background]
```

### **Navigation CityPicker → CategoryPage**
```mermaid
User tap ville  
    ↓
LoadingRoute + TargetPageService("category")
    ↓
PreloadController.startPreload(city, "category")
    ↓
_preloadCategoryGeneric(): 1ère catégorie complète
    ↓
CachingImageProvider.precacheMultiple()
    ↓
Navigation → CategoryPageTemplate
    ↓
HomeShell._onPreloadBecameReady()
    ↓
warmFeaturedCarouselsSilently() [background]
```

### **Changement catégorie (T2 anti-flash)**
```mermaid
User tap catégorie
    ↓
_handleCategoryChange()
    ↓
precacheImage(nextCover) [sync]
    ↓
coverController.updateCategoryWithPreload()
    ↓
ExperienceCarouselWrapper → _attemptPreloadInjection()
    ↓
Structure immédiate (T2 data) + skeleton images
```

---

## 📊 **Architecture données**

### **Clés de storage unifié**
```dart
// CityPage carrousels
"${categoryId}_${sectionId}": List<ExperienceItem>

// CategoryPage featured  
"cat:${categoryId}:featured:${sectionId}": List<ExperienceItem>

// CategoryPage subcategory
"cat:${categoryId}:sub:${subcategoryId}:${sectionId}": List<ExperienceItem>

// Headers catégories
categoryHeaders[categoryId]: CategoryHeader{title, coverUrl}
```

### **Providers ecosystem**
```dart
// ✅ Core preload
preloadControllerProvider : StateNotifierProvider<PreloadController, PreloadData>

// ✅ Pagination unifiée (CityPage)
cityActivitiesPaginationProvider.family.autoDispose : PaginationController<ExperienceItem>

// ✅ Legacy (CategoryPage) 
featuredSectionsByCategoryProvider.family : FutureProvider<List<SectionMetadata>>
subcategorySectionExperiencesProvider.family : FutureProvider<Map<String, List<ExperienceItem>>>

// ✅ Images anti-flash
CachingImageProvider : Cache singleton + bucketisation
```

---

## 🚦 **Points d'injection & détection**

### **ExperienceCarouselWrapper (Universel)**
```dart
// ✅ Injection automatique T0/T2
void _attemptPreloadInjection() {
  final preloadedData = _getPreloadedData();
  if (preloadedData?.isNotEmpty == true) {
    controller.state = currentState.copyWith(
      items: preloadedData,
      isPartial: true,      // ✅ Permet T1
      isLoading: false,     // ✅ Pas de loader
    );
  }
}

// ✅ Détection T1 via ref.listen
ref.listen(paginationProvider, (previous, next) {
  if (!previous.isPartial && next.isPartial) {
    Future.delayed(1500ms, () => controller.completeIfPartial());
  }
});
```

### **GenericExperienceCarousel (Legacy CategoryPage)**
```dart
// ✅ Timer T1 automatique legacy
void _scheduleCompletion() {
  _completionTimer = Timer(Duration(milliseconds: 1500), () {
    widget.onRequestCompletion?.call();
  });
}
```

---

## 📁 **Fichiers architecture complète**

### **Orchestration centrale**
- **`features/preload/application/preload_controller.dart`** : Controller principal T0/T2
- **`features/preload/presentation/loading_route.dart`** : Point d'entrée T0
- **`features/home/presentation/pages/home_shell.dart`** : Orchestrateur T2
- **`features/preload/application/target_page_service.dart`** : Détection type page

### **Pagination unifiée (CityPage)**
- **`features/city_page/application/pagination/city_pagination_providers.dart`** : Controllers par carrousel
- **`features/city_page/presentation/templates/city_page_template.dart`** : Wrappers stateful
- **`core/domain/pagination/paginated_data_provider.dart`** : Base classes pagination

### **Legacy système (CategoryPage)**
- **`features/categories/application/state/categories_provider.dart`** : Providers catégories
- **`features/search/application/state/experience_providers.dart`** : Providers featured
- **`features/city_page/application/providers/category_experiences_controller.dart`** : Controller T1

### **Images anti-flash**
- **`core/common/utils/caching_image_provider.dart`** : Cache unifié
- **`core/common/utils/image_provider_factory.dart`** : Factory API
- **`features/categories/presentation/widgets/delegates/category_cover_delegate.dart`** : Covers

### **Components UI**
- **`features/shared_ui/presentation/widgets/molecules/experience_carousel_wrapper.dart`** : Wrapper universel
- **`features/shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart`** : Carousel legacy
- **`core/theme/components/molecules/infinite_paging_carousel.dart`** : Carousel unifié

---

## ⚡ **Performance & Métriques**

### **Timing objectifs**
```
T0 preload:     < 2.5s (4G)
T1 completion:  1.5s auto
T2 warm:        Background 2-5s
Navigation:     < 100ms (structure prête)
Images:         < 200ms (précachées)
```

### **Memory footprint**
```
PreloadData:           ~2-5MB (structures + URLs)
Image cache:           ~20-50MB (bucketisé)
autoDispose cleanup:   Automatique navigation
Total app stable:      ~80-150MB
```

### **Network efficiency**
```
T0 concurrent:         8 requests max
T2 concurrent:         3-4 requests max  
Image batches:         3 concurrent max
Déduplication:         100% via offset
Cache hit rate:        >90% après warm
```

---

## 🔮 **Roadmap architecture**

### **V3.0 - Unification complète**
- Migration CategoryPage vers pagination unifié
- Suppression système legacy T1
- Cache intelligent avec analytics

### **V4.0 - Prédictif**
- ML pour prédiction navigation utilisateur
- Warm adaptatif selon patterns
- Cache warming intelligent

**✅ Architecture mature, modulaire, et extensible pour toutes les phases de preload.**