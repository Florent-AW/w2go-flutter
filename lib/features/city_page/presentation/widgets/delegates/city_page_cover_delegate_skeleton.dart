import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'city_page_cover_delegate.dart';

/// Skeleton du delegate pendant le chargement
class CityPageCoverDelegateSkeleton extends SliverPersistentHeaderDelegate {
  final double screenWidth;

  CityPageCoverDelegateSkeleton({required this.screenWidth});

  @override
  double get minExtent => CityPageCoverDelegate.coverHeight;

  @override
  double get maxExtent => CityPageCoverDelegate.coverHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Skeletonizer(
      enabled: true,
      child: SizedBox.expand(
        child: CityPageCoverDelegate(
          cityName: 'Nom de la ville',
          activityCount: 42,
          screenWidth: screenWidth,
        ).build(context, 0, false),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}