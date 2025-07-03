import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/domain/models/shared/city_model.dart';
import '../../../../core/common/utils/caching_image_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../application/preload_providers.dart';
import '../application/preload_controller.dart';

class LoadingRoute extends ConsumerStatefulWidget {
  final City targetCity;
  final String targetPageType;

  const LoadingRoute({
    Key? key,
    required this.targetCity,
    required this.targetPageType,
  }) : super(key: key);

  @override
  ConsumerState<LoadingRoute> createState() => _LoadingRouteState();
}

class _LoadingRouteState extends ConsumerState<LoadingRoute> {
  @override
  void initState() {
    super.initState();

    // Démarrer le préchargement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(preloadControllerProvider.notifier).startPreload(
        widget.targetCity,
        widget.targetPageType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final preloadData = ref.watch(preloadControllerProvider);

    // Écouter les changements d'état pour naviguer
    ref.listen(preloadControllerProvider, (previous, next) async {
      if (next.state == PreloadState.ready) {
        // Precache les images avec le context local
        if (next.criticalImageUrls.isNotEmpty) {
          await CachingImageProvider.precacheMultiple(
            next.criticalImageUrls,
            context,
            maxConcurrent: 3,
          );
        }
        _navigateToTarget();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 24),
            Text(
              'Préparation de ${widget.targetCity.cityName}...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTarget() {
    // ✅ CORRECTION: Utiliser Navigator.pushReplacementNamed
    switch (widget.targetPageType) {
      case 'city':
        Navigator.of(context).pushReplacementNamed('/city/${widget.targetCity.id}');
        break;
    // TODO: Ajouter categories plus tard
      default:
        Navigator.of(context).pushReplacementNamed('/city/${widget.targetCity.id}');
    }
  }
}