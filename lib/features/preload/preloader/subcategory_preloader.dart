// lib/features/preload/preloader/subcategory_preloader.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/common/utils/caching_image_provider.dart';

typedef SubcategoryId = String;
typedef CategoryId = String;
typedef CarouselId = String;

class SubcategorySummary {
  final SubcategoryId id;
  SubcategorySummary(this.id);
}

class CarouselSummary {
  final CarouselId id;
  final List<String>? firstImageUrls;
  CarouselSummary(this.id, {this.firstImageUrls});
}

class ItemSummary {
  final String? imageUrl;
  ItemSummary({this.imageUrl});
}

typedef FetchSubcategories = Future<List<SubcategorySummary>> Function(CategoryId categoryId);
typedef FetchCarousels = Future<List<CarouselSummary>> Function(SubcategoryId subcategoryId);
typedef FetchItemsHead = Future<List<ItemSummary>> Function(CarouselId carouselId, {int limit});

class SubcategoryPreloader {
  SubcategoryPreloader._();
  static final SubcategoryPreloader instance = SubcategoryPreloader._();

  // Wiring (nullable + garde)
  FetchSubcategories? fetchSubcategories;
  FetchCarousels? fetchCarousels;
  FetchItemsHead? fetchItemsHead;

  bool get isWired =>
      fetchSubcategories != null &&
          fetchCarousels != null &&
          fetchItemsHead != null;

  bool _busy = false;
  final _doneForCategory = <CategoryId>{};

  Future<void> preloadForCategoryT3({
    required BuildContext context,
    required CategoryId categoryId,
  }) async {
    debugPrint('[T3] 📦 Préload demandé pour catégorie: $categoryId');

    // Wiring manquant
    if (!isWired) {
      debugPrint('[T3] ⚙️ Fetchers non câblés — abort (wireSubcategoryPreloader à appeler au bootstrap)');
      return;
    }

    // Idempotence + mutex global
    if (_doneForCategory.contains(categoryId)) {
      debugPrint('[T3] ⏩ Déjà préchargée: $categoryId — skip.');
      return;
    }
    if (_busy) {
      debugPrint('[T3] ⛔ Occupé par un autre préload — skip $categoryId.');
      return;
    }

    // Déballer proprement les fetchers (non-null à partir d’ici)
    final fSubcats = fetchSubcategories!;
    final fCars = fetchCarousels!;
    final fHead = fetchItemsHead!;

    _busy = true;
    try {
      // 1) Sous-catégories
      final subcats = await fSubcats(categoryId);
      debugPrint('[T3] 🔍 ${subcats.length} sous-catégories trouvées pour $categoryId.');
      if (subcats.isEmpty) {
        _doneForCategory.add(categoryId);
        return;
      }

      // 2) Carousels (parallélisme limité)
      final carousels = <CarouselSummary>[];
      await _pMapLimited<SubcategorySummary>(
        subcats,
            (s) async {
          final list = await fCars(s.id);
          debugPrint('[T3]   ↳ ${list.length} carousels pour sous-cat ${s.id}.');
          carousels.addAll(list);
        },
        concurrency: 3,
      );

      if (carousels.isEmpty) {
        debugPrint('[T3] ⚠️ Aucun carousel trouvé — skip.');
        _doneForCategory.add(categoryId);
        return;
      }

      // 3) Items + 2 premières images précachées
      await _pMapLimited<CarouselSummary>(
        carousels,
            (c) async {
          final items = await fHead(c.id, limit: 2);
          debugPrint('[T3]     Carousel ${c.id} : ${items.length} items récupérés.');

          final urls = (c.firstImageUrls?.take(2).toList() ?? [])
            ..addAll(items.map((e) => e.imageUrl).whereType<String>());
          final uniqueFirstTwo = <String>{};
          for (final u in urls) {
            if (uniqueFirstTwo.length >= 2) break;
            if (u.isEmpty) continue;
            uniqueFirstTwo.add(u);
          }

          for (final url in uniqueFirstTwo) {
            debugPrint('[T3]       📷 Precache image: $url');
            try {
              await CachingImageProvider.precache(url, context);
            } catch (e) {
              debugPrint('[T3]         ❌ Erreur precache: $e');
            }
          }
        },
        concurrency: 4,
      );

      debugPrint('[T3] ✅ Préload terminé pour $categoryId.');
      _doneForCategory.add(categoryId);
    } catch (e, st) {
      debugPrint('[T3] 💥 Erreur préload $categoryId: $e');
      debugPrint(st.toString());
    } finally {
      _busy = false;
    }
  }

  void resetFor(CategoryId categoryId) => _doneForCategory.remove(categoryId);
  void resetAll() => _doneForCategory.clear();
}

/// Map async avec parallélisme limité (KISS)
Future<void> _pMapLimited<T>(
    List<T> list,
    FutureOr<void> Function(T item) worker, {
      int concurrency = 4,
    }) async {
  if (list.isEmpty) return;

  final it = list.iterator;

  Future<void> spawn() async {
    while (true) {
      if (!it.moveNext()) break;
      final T current = it.current; // non-null après moveNext()
      await worker(current);
    }
  }

  final tasks = <Future<void>>[];
  final int lanes = (concurrency < 1)
      ? 1
      : (concurrency > 16)
      ? 16
      : concurrency;

  for (var i = 0; i < lanes; i++) {
    tasks.add(spawn());
  }
  await Future.wait(tasks);
}
