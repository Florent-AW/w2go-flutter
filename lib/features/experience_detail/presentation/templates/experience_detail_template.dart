// lib/features/experience_detail/presentation/templates/experience_detail_template.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../molecules/experience_header.dart';
import '../organisms/experience_body_content.dart';
import '../organisms/experience_floating_action_bar.dart';
import '../../application/providers/experience_detail_providers.dart';

/// ✅ TEMPLATE CLEAN : Orchestrateur minimal selon Atomic Design
class ExperienceDetailTemplate extends ConsumerWidget {
  final ExperienceItem experienceItem;
  final String heroTag;
  final bool showBody;
  final VoidCallback onDismiss;

  const ExperienceDetailTemplate({
    Key? key,
    required this.experienceItem,
    required this.heroTag,
    required this.showBody,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(experienceDetailProvider(experienceItem));

    final imageUrls = detailState.maybeWhen(
      loaded: (details) => details.imageUrls,
      orElse: () => [experienceItem.mainImageUrl ?? ''],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ✅ ATOMIC DESIGN : CustomScrollView avec composants séparés
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // ✅ MOLECULE : Header toujours visible
              SliverToBoxAdapter(
                child: ExperienceHeader(
                  imageUrls: imageUrls,
                  heroTag: heroTag,
                  experienceId: experienceItem.id,
                  onDismiss: onDismiss,
                ),
              ),

              // ✅ ORGANISM : Corps conditionnel
              SliverToBoxAdapter(
                child: AnimatedOpacity(
                  opacity: showBody ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: ExperienceBodyContent(
                    experienceItem: experienceItem,
                  ),
                ),
              ),
            ],
          ),

          // ✅ ORGANISM : FloatingActionBar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: showBody ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: ExperienceFloatingActionBar(
                experienceItem: experienceItem,
              ),
            ),
          ),
        ],
      ),
    );
  }
}