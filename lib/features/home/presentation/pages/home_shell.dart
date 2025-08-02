// lib/features/home/presentation/pages/home_shell.dart

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../categories/presentation/pages/category_page.dart';
import '../../../city_page/presentation/pages/city_page.dart';
import '../../../shared_ui/presentation/widgets/organisms/generic_bottom_bar.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../../preload/application/preload_providers.dart';
import '../../../preload/application/preload_controller.dart';
import '../../../../core/domain/models/shared/city_model.dart';

class HomeShell extends ConsumerStatefulWidget {
  /// Tab initial à afficher
  final BottomNavTab initialTab;

  const HomeShell({
    Key? key,
    this.initialTab = BottomNavTab.explorer,
  }) : super(key: key);

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  late BottomNavTab _currentTab;
  bool _hasInitialized = false;
  bool _isTransitioning = false;

  // Contrôle opacity
  double _overlayOpacity = 1.0;

  // Garde anti-doublon
  City? _lastPreloadCity;
  String? _lastPreloadTarget;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Initialisation avec protection
    if (!_hasInitialized) {
      _hasInitialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentCity = ref.read(selectedCityProvider);
        if (currentCity != null) {
          print('🏙️ INIT: Ville déjà sélectionnée ${currentCity.cityName}, déclenchement preload');
          _triggerPreload(currentCity);
        }
      });
    }

    // ✅ Écouter changements de ville
    ref.listen<City?>(selectedCityProvider, (previous, next) {
      print('🔥 HOME SHELL LISTEN: previous=${previous?.cityName}, next=${next?.cityName}');

      if (next != null && (previous == null || previous.id != next.id)) {
        print('🌍 TRIGGER UNIVERSEL: Déclenchement preload pour ${next.cityName}');
        _triggerPreload(next);
      }
    });

    // ✅ NOUVEAU : Écouter fin preload pour lever overlay
    ref.listen<PreloadData>(preloadControllerProvider, (previous, next) {
      if (previous?.state != PreloadState.ready && next.state == PreloadState.ready) {
        print('✅ PRELOAD READY: Lever overlay à la prochaine frame');
        _onPreloadBecameReady();
      }
    });

    final preloadData = ref.watch(preloadControllerProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    // ✅ CONDITION OVERLAY : Preload en cours OU transition
    final shouldShowOverlay = (preloadData.state == PreloadState.loading || _isTransitioning)
        && selectedCity != null;

    print('🏠 HOME SHELL BUILD: overlay=$shouldShowOverlay, preloadState=${preloadData.state}, isTransitioning=$_isTransitioning');

    return Scaffold(
      body: Stack(
        children: [
          // ⚡️ TOUJOURS construire la page cible (wrappers montent immédiatement)
          PageTransitionSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation, secondaryAnimation) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                fillColor: Theme.of(context).colorScheme.background,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey(_currentTab),
              child: _getPageForTab(_currentTab), // CityPage/CategoryPage construites immédiatement
            ),
          ),

          // 🔵 OVERLAY avec fade-out élégant
          if (shouldShowOverlay)
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _overlayOpacity,
                duration: const Duration(milliseconds: 250), // ✅ Fade fluide 250ms
                curve: Curves.easeOutCubic, // ✅ Courbe élégante
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          'Chargement de ${selectedCity!.cityName}...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Préparation des expériences',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: GenericBottomBar(
        selectedTab: _currentTab,
        onTabSelected: (tab) {
          if (tab != _currentTab) {
            setState(() => _currentTab = tab);
          }
        },
      ),
    );
  }

  /// ✅ Déclenche le preload avec le bon targetPageType
  void _triggerPreload(City city) {
    try {
      final targetPageType = _currentTab == BottomNavTab.visiter ? 'city' : 'category';

      if (_lastPreloadCity?.id == city.id && _lastPreloadTarget == targetPageType) {
        print('⚠️ PRELOAD SKIP: Déjà lancé pour ${city.cityName} ($targetPageType)');
        return;
      }

      _lastPreloadCity = city;
      _lastPreloadTarget = targetPageType;

      // ✅ NOUVEAU : Reset opacité pour nouveau preload
      setState(() {
        _overlayOpacity = 1.0;
      });

      print('🚀 TRIGGER PRELOAD: ${city.cityName} pour $targetPageType');
      ref.read(preloadControllerProvider.notifier).startPreload(city, targetPageType);

    } catch (e) {
      print('❌ TRIGGER: Erreur preload $e');
    }
  }


  /// Retourne la page correspondant au tab
  Widget _getPageForTab(BottomNavTab tab) {
    switch (tab) {
      case BottomNavTab.explorer:
        return const CategoryPage();
      case BottomNavTab.visiter:
        return const CityPage();
      case BottomNavTab.favoris:
        return const Scaffold(
          body: Center(child: Text('🚧 Favoris - À implémenter')),
        );
      case BottomNavTab.profil:
        return const Scaffold(
          body: Center(child: Text('🚧 Profil - À implémenter')),
        );
    }
  }

  /// ✅ Lever overlay avec fade élégant
  void _onPreloadBecameReady() {
    setState(() {
      _isTransitioning = true;
    });

    // ⚡️ Attendre une frame pour que l'injection soit garantie
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        print('🎨 FADE OUT: Démarrage animation overlay');

        // ✅ FADE OUT : Animer l'opacité vers 0
        setState(() {
          _overlayOpacity = 0.0;
        });

        // ✅ SUPPRIMER après animation (250ms)
        Future.delayed(const Duration(milliseconds: 250), () {
          if (mounted) {
            print('🚀 OVERLAY REMOVED: Animation terminée');
            setState(() {
              _isTransitioning = false;
              _overlayOpacity = 1.0; // Reset pour prochaine fois
            });
          }
        });
      }
    });
  }

}