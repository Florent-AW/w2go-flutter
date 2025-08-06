// lib/core/common/utils/image_provider_factory.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'caching_image_provider.dart';

/// Factory simplifié - délègue tout à CachingImageProvider unifié
class ImageProviderFactory {
  /// ✅ Provider unifié pour covers (même API que vignettes)
  static ImageProvider coverProvider(String url, String categoryId) {
    // ✅ Utilise la même API unifiée - plus de cacheKey spécial
    return CachingImageProvider.of(url);
  }

  /// ✅ Provider fallback (même logique)
  static ImageProvider coverFallbackProvider(String url, String categoryId) {
    return CachingImageProvider.of(url);
  }

  /// ✅ Provider pour vignettes - MÊME API unifiée
  static ImageProvider thumbnailProvider(String url) {
    return CachingImageProvider.of(url);
  }
}