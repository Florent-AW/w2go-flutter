// lib/core/common/utils/caching_image_provider.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Provider unifié avec clés de cache STABLES
/// Évite les cache miss par bucketisation + cacheKey normalisée
class CachingImageProvider extends CachedNetworkImageProvider {
  CachingImageProvider._(String url, {int? maxWidth, String? cacheKey})
      : super(
    url,
    maxWidth: maxWidth,
    // ✅ CRITIQUE : cacheKey stable pour éviter miss sur query-strings
    cacheKey: cacheKey,
  );

  // ✅ Cache singleton selon expert - MÊME INSTANCE partout
  static final Map<String, CachingImageProvider> _cache = {};

  /// ✅ Bucketise largeur par multiples de 16 pour stabilité cache
  static int _bucketWidth(int pixels) => (pixels / 16).round() * 16;

  /// ✅ Normalise URL (supprime ? final + espaces)
  static String _normalizeUrl(String url) {
    var u = url.trim();
    if (u.endsWith('?')) u = u.substring(0, u.length - 1);
    return u;
  }

  /// ✅ Génère cacheKey stable sans query-strings volatiles
  static String _stableCacheKey(String url, {int? width}) {
    try {
      final uri = Uri.parse(url);
      // Path uniquement (sans query) pour stabilité
      final pathOnly = '${uri.scheme}://${uri.host}${uri.path}';
      return width != null ? '${pathOnly}|w=${width}' : pathOnly;
    } catch (e) {
      // Fallback si URL invalide
      return width != null ? '${url}|w=${width}' : url;
    }
  }

  /// Retourne EXACTEMENT la même instance pour chaque URL+largeur bucketisée
  static CachingImageProvider of(String url, {int? maxWidth}) {
    if (url.isEmpty) {
      url = 'placeholder'; // URL placeholder pour éviter erreurs
    }

    // ✅ 1) Normaliser URL
    final normalizedUrl = _normalizeUrl(url);

    // ✅ 2) Bucketiser largeur (stabilité cache)
    final bucketedWidth = _bucketWidth(maxWidth ?? 800);

    // ✅ 3) Clé composite stable
    final cacheKey = '${normalizedUrl}_w${bucketedWidth}';

    // ✅ 4) CacheKey stable pour disk cache
    final stableCacheKey = _stableCacheKey(normalizedUrl, width: bucketedWidth);

    return _cache.putIfAbsent(
      cacheKey,
          () => CachingImageProvider._(
        normalizedUrl,
        maxWidth: bucketedWidth, // ❌ PAS de maxHeight (instable)
        cacheKey: stableCacheKey, // ✅ Stable disk cache key
      ),
    );
  }

  /// Helper : Calcule largeur bucketisée depuis une largeur logique
  static int bucketedWidthFromLogical(double logicalWidth, double devicePixelRatio) {
    final physicalWidth = (logicalWidth * devicePixelRatio).round();
    return _bucketWidth(physicalWidth.clamp(320, 1536));
  }

  /// Pré-cache une image avec dimensions bucketisées
  static Future<void> precache(
      String url,
      BuildContext context, {
        int? cacheWidth, // ❌ Pas de cacheHeight
      }) async {
    if (url.isEmpty) return;

    try {
      final bucketedWidth = _bucketWidth(cacheWidth ?? 800);
      final provider = of(url, maxWidth: bucketedWidth);
      await precacheImage(provider, context);

      debugPrint('✅ PRECACHED: $url (bucket: ${bucketedWidth}px)');
    } catch (e) {
      debugPrint('⚠️ PRECACHE FAILED: $url - $e');
    }
  }

  /// Pré-cache multiple avec buckets cohérents
  static Future<void> precacheMultiple(
      List<String> urls,
      BuildContext context, {
        int? cacheWidth, // ❌ Pas de cacheHeight
        int maxConcurrent = 3,
      }) async {

    final bucketedWidth = _bucketWidth(cacheWidth ?? 800);
    debugPrint('🖼️ PRECACHING ${urls.length} images (bucket: ${bucketedWidth}px)');

    // Traitement par batch pour éviter surcharge réseau
    for (int i = 0; i < urls.length; i += maxConcurrent) {
      final batch = urls.skip(i).take(maxConcurrent);
      await Future.wait(
        batch.map((url) => precache(
          url,
          context,
          cacheWidth: bucketedWidth, // ✅ Bucket cohérent
        )),
      );
    }

    debugPrint('✅ PRECACHING COMPLETED: ${urls.length} images');
  }

  /// Debug : Status cache pour une URL avec ImageConfiguration cohérente
  static Future<bool> isCachedInMemory(String url, int width, BuildContext context) async {
    try {
      final provider = of(url, maxWidth: _bucketWidth(width));
      // ✅ CRITIQUE : Même ImageConfiguration que le rendu réel
      final key = await provider.obtainKey(
        ImageConfiguration(devicePixelRatio: MediaQuery.of(context).devicePixelRatio),
      );
      final status = PaintingBinding.instance.imageCache.statusForKey(key);
      return status != null;
    } catch (e) {
      return false;
    }
  }

  /// Nettoie le cache complet
  static void clearCache() {
    _cache.clear();
    PaintingBinding.instance.imageCache.clear();
  }

  /// Nettoie une URL spécifique du cache
  static void clearUrl(String url) {
    final normalizedUrl = _normalizeUrl(url);
    _cache.removeWhere((key, value) => key.contains(normalizedUrl));
  }

  /// Debug : Stats du cache
  static Map<String, dynamic> getCacheStats() {
    return {
      'memoryProviders': _cache.length,
      'imageCache': PaintingBinding.instance.imageCache.currentSize,
      'imageCacheBytes': PaintingBinding.instance.imageCache.currentSizeBytes,
    };
  }

  /// Debug : Buckets actifs
  static List<int> getActiveBuckets() {
    return _cache.keys
        .map((k) => RegExp(r'_w(\d+)$').firstMatch(k)?.group(1))
        .where((w) => w != null)
        .map((w) => int.parse(w!))
        .toSet()
        .toList()
      ..sort();
  }
}