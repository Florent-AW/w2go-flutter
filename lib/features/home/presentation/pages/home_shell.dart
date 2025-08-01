// lib/features/home/presentation/pages/home_shell.dart

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../categories/presentation/pages/category_page.dart';
import '../../../city_page/presentation/pages/city_page.dart';
import '../../../shared_ui/presentation/widgets/organisms/generic_bottom_bar.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../../preload/application/all_data_preloader.dart';
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

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;

    // ✅ TRIGGER UNIVERSEL SIMPLIFIÉ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<City?>(selectedCityProvider, (previous, next) {
        if (next != null && (previous == null || previous.id != next.id)) {
          print('🌍 TRIGGER UNIVERSEL: Changement de ville ${next.cityName}');
          ref.read(allDataPreloaderProvider.notifier).load3ItemsEverywhere(next.id);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Écouter le state preload pour rebuild
    final preloadData = ref.watch(allDataPreloaderProvider);
    final isPreloading = ref.watch(allDataPreloaderProvider.notifier).isLoading;
    final selectedCity = ref.watch(selectedCityProvider);

    // ✅ LOADING BLOQUANT : Afficher que l'écran bleu si preload en cours
    if (isPreloading && selectedCity != null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 16),
              Text(
                'Chargement de ${selectedCity.cityName}...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Préparation des expériences',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ PAGES NORMALES : Seulement quand preload terminé
    return Scaffold(
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
            setState(() => _currentTab = tab);
          }
        },
      ),
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
