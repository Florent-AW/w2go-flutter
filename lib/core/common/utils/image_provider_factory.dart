import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageProviderFactory {
  /// ✅ Provider unifié EXACT pour covers (même que delegate)
  static ImageProvider coverProvider(String url, String categoryId) {
    return CachedNetworkImageProvider(
      url,
      cacheKey: 'category_cover_${categoryId}_$url', // ✅ MÊME clé que delegate
    );
  }

  /// ✅ Provider fallback (même que delegate)
  static ImageProvider coverFallbackProvider(String url, String categoryId) {
    return CachedNetworkImageProvider(
      url,
      cacheKey: 'category_cover_$categoryId', // ✅ MÊME clé que delegate
    );
  }

  /// ✅ Provider pour vignettes
  static ImageProvider thumbnailProvider(String url) {
    return CachedNetworkImageProvider(url); // Pas de cacheKey spéciale
  }
}