// core/adapters/cache/hive_recent_terms_adapter.dart

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/ports/search/recent_terms_port.dart';

class HiveRecentTermsAdapter implements RecentTermsPort {
  static const String _boxName = 'recentTermsV1';
  late Box<String> _box;

  Future<void> initializeAsync() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<String>(_boxName);
    } else {
      _box = Hive.box<String>(_boxName);
    }
  }

  @override
  Future<List<String>> getRecentTerms({int limit = 8}) async {
    if (!Hive.isBoxOpen(_boxName)) await initializeAsync();
    final List<_Entry> entries = [];
    for (var i = 0; i < _box.length; i++) {
      try {
        final jsonString = _box.getAt(i);
        if (jsonString == null) continue;
        final Map<String, dynamic> map = jsonDecode(jsonString);
        entries.add(_Entry(map['term'] as String, (map['ts'] as num).toInt()));
      } catch (_) {}
    }
    entries.sort((a, b) => b.ts.compareTo(a.ts));
    return entries.map((e) => e.term).toSet().take(limit).toList();
  }

  @override
  Future<void> addRecentTerm(String term, {int maxEntries = 8}) async {
    final raw = term.trim();
    if (raw.isEmpty) return;
    if (!Hive.isBoxOpen(_boxName)) await initializeAsync();

    final norm = raw.toLowerCase();

    // Build current entries with indices and parsed maps
    final List<({int index, Map<String, dynamic> map})> current = [];
    for (var i = 0; i < _box.length; i++) {
      final jsonString = _box.getAt(i);
      if (jsonString == null) continue;
      try {
        final map = jsonDecode(jsonString) as Map<String, dynamic>;
        current.add((index: i, map: map));
      } catch (e) {
        // keep going even if a record is corrupted
      }
    }

    // Remove any existing entry with same normalized term
    for (final entry in current.reversed) {
      final existingNorm = (entry.map['norm'] ?? (entry.map['term']?.toString() ?? '')).toString().toLowerCase();
      if (existingNorm == norm) {
        await _box.deleteAt(entry.index);
      }
    }

    // Append new entry with explicit norm and timestamp
    final nowTs = DateTime.now().millisecondsSinceEpoch;
    await _box.add(jsonEncode({'term': raw, 'norm': norm, 'ts': nowTs}));

    // Enforce maxEntries: keep newest by ts
    // Read all back, sort by ts desc, and delete extras by index mapping
    final List<({int index, Map<String, dynamic> map})> all = [];
    for (var i = 0; i < _box.length; i++) {
      final jsonString = _box.getAt(i);
      if (jsonString == null) continue;
      try {
        final map = jsonDecode(jsonString) as Map<String, dynamic>;
        all.add((index: i, map: map));
      } catch (_) {}
    }
    all.sort((a, b) => ((b.map['ts'] as num? ?? 0).toInt()).compareTo((a.map['ts'] as num? ?? 0).toInt()));
    if (all.length > maxEntries) {
      final toDelete = all.sublist(maxEntries);
      // Delete by current indices (descending to keep positions valid)
      final indices = toDelete.map((e) => e.index).toList()..sort((a, b) => b.compareTo(a));
      for (final idx in indices) {
        if (idx >= 0 && idx < _box.length) {
          await _box.deleteAt(idx);
        }
      }
    }
  }

  @override
  Future<void> clear() async {
    if (!Hive.isBoxOpen(_boxName)) await initializeAsync();
    await _box.clear();
  }
}

class _Entry {
  final String term;
  final int ts;
  _Entry(this.term, this.ts);
}
