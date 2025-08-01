// lib/features/preload/presentation/loading_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../application/all_data_preloader.dart';

class LoadingScreen extends ConsumerWidget {
  final City city;
  const LoadingScreen({Key? key, required this.city}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Démarre le preload APRÈS le build pour éviter l'erreur Riverpod
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(allDataPreloaderProvider.notifier)
          .load3ItemsAllCarousels(city.id)
          .then((_) => Navigator.of(context).pushReplacementNamed('/category'));
    });

    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
