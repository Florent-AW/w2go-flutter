// lib/features/home/presentation/pages/home_shell.dart

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../categories/presentation/pages/category_page.dart';
import '../../../city_page/presentation/pages/city_page.dart';
import '../../../shared_ui/presentation/widgets/organisms/generic_bottom_bar.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../../../core/application/all_data_preloader.dart';
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

// ✅ NOUVEAU
class _HomeShellState extends ConsumerState<HomeShell> {
  late BottomNavTab _currentTab;
  bool _hasTriggeredInitial = false;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;

    // ✅ TRIGGER UNIVERSEL : Écouter les changements de ville
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<City?>(selectedCityProvider, (previous, next) {
        if (next != null && previous?.id != next.id) {
          print('🌍 TRIGGER UNIVERSEL: Changement de ville détecté - ${next.cityName}');
          ref.read(allDataPreloaderProvider.notifier).loadCompleteCity(next.id);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ TRIGGER INITIAL : Vérifier si preload nécessaire au premier build (une seule fois)
    if (!_hasTriggeredInitial) {
      final selectedCity = ref.watch(selectedCityProvider);
      final preloadData = ref.watch(allDataPreloaderProvider);

      // Si ville sélectionnée mais pas de données preload → déclencher
      if (selectedCity != null && preloadData.isEmpty) {
        _hasTriggeredInitial = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('🌍 TRIGGER INITIAL: Ville détectée sans preload - ${selectedCity.cityName}');
          ref.read(allDataPreloaderProvider.notifier).loadCompleteCity(selectedCity.id);
        });
      }
    }

    // ✅ État de chargement global
    final isPreloading = ref.watch(allDataPreloaderProvider.notifier).isLoading;
    final selectedCity = ref.watch(selectedCityProvider);

    return Stack(
      children: [
        // Page principale avec navigation par onglets
        Scaffold(
          body: PageTransitionSwitcher(
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
              child: _getPageForTab(_currentTab),
            ),
          ),
          bottomNavigationBar: GenericBottomBar(
            selectedTab: _currentTab,
            onTabSelected: (tab) {
              if (tab != _currentTab) {
                setState(() {
                  _currentTab = tab;
                });
              }
            },
          ),
        ),

        // ✅ Overlay préchargement : écran bleu + spinner
        if (isPreloading && selectedCity != null)
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
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
}
