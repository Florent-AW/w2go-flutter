// lib/features/favorites/presentation/pages/favorites_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/favorites_sections_provider.dart';
import '../templates/favorites_template.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const FavoritesTemplate();
  }
}
