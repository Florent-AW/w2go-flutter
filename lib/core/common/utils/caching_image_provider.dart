// lib/core/common/utils/caching_image_provider.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Provider unifié qui garantit la MÊME instance pour chaque URL
/// CRITIQUE pour éviter re-upload GPU pendant Hero transitions
class CachingImageProvider extends CachedNetworkImageProvider {
  CachingImageProvider._(String url, {int? maxWidth, int? maxHeight})
      : super(
    url,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
  );

  // ✅ Cache singleton selon expert Romain - MÊME INSTANCE partout
  static final Map<String, CachingImageProvider> _cache = {};

  /// Retourne EXACTEMENT la même instance pour chaque URL
  static CachingImageProvider of(String url, {int? maxWidth, int? maxHeight}) {
    if (url.isEmpty) {
      // Utiliser une URL placeholder pour éviter erreurs
      url = 'placeholder';
    }

    // ✅ Clé composite incluant les dimensions pour éviter conflits
    final cacheKey = '${url}_${maxWidth ?? 800}_${maxHeight ?? 600}';

    return _cache.putIfAbsent(
      cacheKey,
          () => CachingImageProvider._(
        url,
        maxWidth: maxWidth ?? 800,  // ✅ Limite GPU upload par défaut
        maxHeight: maxHeight ?? 600, // ✅ Évite fichiers énormes
      ),
    );
  }

  /// Pré-cache une image avec optimisations GPU
  static Future<void> precache(
      String url,
      BuildContext context, {
        int? cacheWidth,
        int? cacheHeight,
      }) async {
    if (url.isEmpty) return;

    try {
      final provider = of(
        url,
        maxWidth: cacheWidth ?? 800,
        maxHeight: cacheHeight ?? 600,
      ); // ✅ Même instance garantie
      await precacheImage(provider, context);
    } catch (e) {
      // ✅ Fail silencieux pour éviter crashes sur images invalides
      debugPrint('⚠️ CachingImageProvider.precache failed for $url: $e');
    }
  }

  /// Pré-cache une liste d'images de manière optimisée
  static Future<void> precacheMultiple(
      List<String> urls,
      BuildContext context, {
        int? cacheWidth,
        int? cacheHeight,
        int maxConcurrent = 3,
      }) async {
    // ✅ Traitement par batch pour éviter surcharge réseau
    for (int i = 0; i < urls.length; i += maxConcurrent) {
      final batch = urls.skip(i).take(maxConcurrent);
      await Future.wait(
        batch.map((url) => precache(
          url,
          context,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
        )),
      );
    }
  }

  /// Nettoie le cache complet
  static void clearCache() {
    _cache.clear();
  }

  /// Nettoie une URL spécifique du cache
  static void clearUrl(String url) {
    _cache.removeWhere((key, value) => key.startsWith(url));
  }

  /// Taille du cache actuel
  static int get cacheSize => _cache.length;

  /// Debug : Liste toutes les URLs en cache
  static List<String> get cachedUrls {
    return _cache.keys.toList();
  }

  /// Vérifie si une URL est en cache
  static bool isCached(String url) {
    return _cache.keys.any((key) => key.startsWith(url));
  }
}