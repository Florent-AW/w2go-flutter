// lib/features/city_page/presentation/pages/city_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../experience_detail/presentation/pages/experience_detail_page.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../templates/city_page_template.dart';

/// Page ville - Affiche les expériences par catégorie pour une ville donnée
/// Variante simplifiée de CategoryPage sans sous-catégories
class CityPage extends ConsumerWidget {
  /// ID de la ville (optionnel - utilise la ville sélectionnée si null)
  final String? cityId;

  const CityPage({
    Key? key,
    this.cityId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Utiliser la ville fournie ou celle sélectionnée
    final selectedCity = ref.watch(selectedCityProvider);
    final effectiveCityId = cityId ?? selectedCity?.id;

    // Si aucune ville disponible, rediriger vers l'écran de sélection
    if (effectiveCityId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/welcome');
      });

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return CityPageTemplate(
      cityId: effectiveCityId,
      openBuilder: _buildOpenBuilder(),
    );
  }

  /// Builder pour ouvrir une expérience (navigation unifiée)
  Widget Function(BuildContext, VoidCallback, ExperienceItem)? _buildOpenBuilder() {
    return (context, action, experience) {
      return ExperienceDetailPage(
        experienceItem: experience,
        onClose: action,
      );
    };
  }
}