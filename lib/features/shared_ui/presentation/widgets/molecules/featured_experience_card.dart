// lib/features/shared_ui/presentation/widgets/molecules/featured_experience_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../../core/common/utils/navigation_utils.dart';
import '../atoms/event_date_badge.dart';
import 'activity_card_header.dart';
import 'activity_card_footer.dart';

// ✅ SOLUTION A : StatefulWidget avec AutomaticKeepAliveClientMixin
class FeaturedExperienceCard extends StatefulWidget {
  final ExperienceItem experience;
  final String heroTag;
  final double? overrideDistance;
  final bool isFavorite;
  final bool showSubcategory;
  final List<String> tags;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePress;
  final bool showDistance;
  final Widget Function(BuildContext, VoidCallback)? openBuilder;
  final double? width;

  const FeaturedExperienceCard({
    Key? key,
    required this.experience,
    required this.heroTag,
    this.overrideDistance,
    this.isFavorite = false,
    this.tags = const [],
    this.onTap,
    this.onFavoritePress,
    this.showSubcategory = true,
    this.openBuilder,
    this.showDistance = true,
    this.width,
  }) : super(key: key);

  @override
  State<FeaturedExperienceCard> createState() => _FeaturedExperienceCardState();
}

// ✅ SOLUTION A : Mixin pour garder le widget en vie
class _FeaturedExperienceCardState extends State<FeaturedExperienceCard>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // ✅ Garde le Hero en mémoire

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ Obligatoire pour KeepAlive

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          if (widget.openBuilder != null) {
            print('📱 CARD TAP: Utilisation openBuilder personnalisé');
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => widget.openBuilder!(context, () => Navigator.pop(context)),
              ),
            );
          } else if (widget.onTap != null) {
            print('🔘 CARD TAP: Utilisation onTap callback personnalisé');
            widget.onTap!();
          } else {
            print('🛣️ CARD TAP: Navigation par défaut');

            if (widget.experience.isEvent) {
              print('📅 CARD TAP: Navigation vers événement: ${widget.experience.name}');
              if (widget.experience.asEvent != null) {
                NavigationUtils.navigateToEventDetail(
                  context,
                  event: widget.experience.asEvent!,
                  heroTag: widget.heroTag,
                );
              } else {
                print('❌ CARD TAP: experience.asEvent est null !');
              }
            } else {
              print('🏛️ CARD TAP: Navigation vers activité avec NavigationUtils');

              if (widget.experience.asActivity != null) {
                NavigationUtils.navigateToActivityDetail(
                  context,
                  activity: widget.experience.asActivity!,
                  heroTag: widget.heroTag,
                );
              } else {
                print('❌ CARD TAP: experience.asActivity est null !');
              }
            }
          }
        },
        child: _cardVisual(),
      ),
    );
  }

  Widget _cardVisual() {
    final height = AppDimensions.activityCardHeight;
    final headerHeight = height * AppDimensions.activityCardHeaderHeight;

    return RepaintBoundary(
      child: Container(
        width: widget.width,
        height: height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ActivityCardHeader(
                  imageUrl: widget.experience.mainImageUrl ?? '',
                  height: headerHeight,
                  isFavorite: widget.isFavorite,
                  onFavoritePress: widget.onFavoritePress,
                  heroTag: widget.heroTag,
                ),
                if (widget.experience.isEvent && widget.experience.startDate != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: EventDateBadge(
                      startDate: widget.experience.startDate!,
                      endDate: widget.experience.endDate,
                      isCompact: true,
                    ),
                  ),
              ],
            ),
            Expanded(
              child: ActivityCardFooter(
                title: widget.experience.name,
                city: widget.experience.city ?? 'Ville inconnue',
                category: widget.experience.categoryName ?? '',
                subcategoryName: widget.experience.subcategoryName,
                subcategoryIcon: widget.experience.subcategoryIcon,
                distance: widget.overrideDistance ?? widget.experience.distance,
                tags: widget.tags,
                showSubcategory: widget.showSubcategory,
                showDistance: widget.showDistance,
              ),
            ),
          ],
        ),
      ),
    );
  }
}