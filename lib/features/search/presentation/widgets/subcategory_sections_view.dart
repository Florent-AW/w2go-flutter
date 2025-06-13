// lib/features/search/presentation/widgets/subcategory_sections_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/state/selected_subcategory_state.dart';
import '../../../../../core/domain/models/config/subcategory_section_config.dart';
import '../../../../../core/domain/ports/providers/config/remote_config_provider.dart';

class SubcategorySectionsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSubcategory = ref.watch(selectedSubcategoryProvider);

    return ref.watch(subcategorySectionsConfigProvider(selectedSubcategory?.id)).when(
      data: (sections) => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return _buildSection(section);
        },
      ),
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(error),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Erreur de chargement: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(
        3, // Nombre de sections en chargement
            (index) => Padding(
          padding: EdgeInsets.only(
            top: index == 0 ? 8 : 24,
          ),
          child: _buildShimmerSection(),
        ),
      ),
    );
  }

  Widget _buildSection(SubcategorySectionConfig section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            section.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildLoadingCard(), // Remplacé ShimmerLoading par une méthode helper
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildShimmerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            width: 150,
            height: 24,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: 3,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildLoadingCard(),
            ),
          ),
        ),
      ],
    );
  }
}