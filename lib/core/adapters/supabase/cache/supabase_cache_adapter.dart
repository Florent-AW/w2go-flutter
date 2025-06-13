// lib/core/adapters/supabase/cache/supabase_cache_adapter.dart

import 'dart:convert';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Adapter de cache minimal utilisant une table Supabase
///
/// Stockage simple clé-valeur avec TTL automatique
/// Compression gzip pour optimiser l'espace
class SupabaseCacheAdapter {
  final SupabaseClient _client;

  SupabaseCacheAdapter(this._client);

  /// Récupère une valeur depuis le cache
  ///
  /// Retourne null si:
  /// - Clé inexistante
  /// - Entrée expirée (cleanup automatique)
  /// - Erreur de décompression
  Future<String?> get(String key) async {
    try {
      final response = await _client
          .from('recommendation_cache')
          .select('data, expires_at')
          .eq('cache_key', key)
          .single();

      // Vérifier expiration
      final expiresAt = DateTime.parse(response['expires_at']);
      if (expiresAt.isBefore(DateTime.now())) {
        // Cleanup asynchrone de l'entrée expirée
        _deleteExpired(key);
        return null;
      }

      // Décompresser les données
      final compressedData = response['data'] as String;
      final decompressed = _decompress(compressedData);

      print('🗄️ CACHE HIT: $key');
      return decompressed;

    } catch (e) {
      // Cache miss ou erreur de décompression
      print('🗄️ CACHE MISS: $key');
      return null;
    }
  }

  /// Stocke une valeur dans le cache avec TTL
  ///
  /// Compresse automatiquement les données avec gzip
  /// Utilise UPSERT pour éviter les conflits de clés
  Future<void> set(String key, String value, Duration ttl) async {
    try {
      final expiresAt = DateTime.now().add(ttl);
      final compressedValue = _compress(value);

      await _client
          .from('recommendation_cache')
          .upsert({
        'cache_key': key,
        'data': compressedValue,
        'expires_at': expiresAt.toIso8601String(),
      });

      print('💾 CACHE SET: $key (expires: ${expiresAt.toIso8601String()})');

    } catch (e) {
      print('❌ CACHE SET ERROR: $key - $e');
      // Fail silently - cache n'est pas critique
    }
  }

  /// Supprime une entrée expirée (cleanup asynchrone)
  Future<void> _deleteExpired(String key) async {
    try {
      await _client
          .from('recommendation_cache')
          .delete()
          .eq('cache_key', key);
    } catch (e) {
      // Ignore les erreurs de cleanup
    }
  }

  /// Compresse une chaîne avec gzip + base64
  String _compress(String data) {
    try {
      final bytes = utf8.encode(data);
      final compressed = gzip.encode(bytes);
      return base64Encode(compressed);
    } catch (e) {
      // Si compression échoue, retourner tel quel
      return data;
    }
  }

  /// Décompresse une chaîne base64 + gzip
  String _decompress(String compressedData) {
    try {
      final compressed = base64Decode(compressedData);
      final decompressed = gzip.decode(compressed);
      return utf8.decode(decompressed);
    } catch (e) {
      // Si décompression échoue, considérer comme donnée brute
      return compressedData;
    }
  }

  /// Nettoie toutes les entrées expirées (maintenance)
  /// À appeler périodiquement ou via cron job
  Future<void> cleanupExpired() async {
    try {
      final deleted = await _client
          .from('recommendation_cache')
          .delete()
          .lt('expires_at', DateTime.now().toIso8601String());

      print('🧹 CACHE CLEANUP: Supprimé ${deleted.length} entrées expirées');
    } catch (e) {
      print('❌ CACHE CLEANUP ERROR: $e');
    }
  }
}