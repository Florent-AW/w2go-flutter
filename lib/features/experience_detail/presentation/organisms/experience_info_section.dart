import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/components/atoms/section_title.dart';
import '../../../../core/domain/services/shared/experience_info_factory.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../experience_detail/presentation/molecules/info_item_tile.dart';
import '../../application/providers/experience_detail_providers.dart';

class ExperienceInfoSection extends ConsumerWidget {
  final ExperienceItem experienceItem;

  const ExperienceInfoSection({
    Key? key,
    required this.experienceItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(experienceDetailProvider(experienceItem));

    return detailState.when(
      initial: () => _buildSkeleton(context),
      loading: () => _buildSkeleton(context),
      error: (_) => const SizedBox.shrink(),
      loaded: (details) {
        final infoItems = ExperienceInfoFactory.createInfoItems(details);

        if (infoItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle.secondary(
              text: 'Détails pratiques',
            ),

            SizedBox(height: AppDimensions.spacingXxxs),

            // Liste une colonne des InfoItems
            Column(
              children: infoItems.map((item) =>
                  Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.spacingXs),
                    child: InfoItemTile(item: item),
                  )
              ).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre skeleton
        Container(
          width: 120,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.neutral300,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),

        SizedBox(height: AppDimensions.spacingXs),

        // Skeleton items
        ...List.generate(
          3,
              (index) => Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.spacingXs),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.neutral300,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
          ),
        ),
      ],
    );
  }
}