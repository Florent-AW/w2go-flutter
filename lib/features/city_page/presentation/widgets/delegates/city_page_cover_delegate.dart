import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';

/// Délégué pour la cover full-screen de la city page
class CityPageCoverDelegate extends SliverPersistentHeaderDelegate {
  final String cityName;
  final int activityCount;
  final double screenWidth;

  static const double coverHeight = 300.0;

  CityPageCoverDelegate({
    required this.cityName,
    required this.activityCount,
    required this.screenWidth,
  });

  @override
  double get minExtent => coverHeight;

  @override
  double get maxExtent => coverHeight;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Choisir l'image selon la taille d'écran
    final imageUrl = screenWidth > 600
        ? 'https://hxrlnebwhznskjhzkjit.supabase.co/storage/v1/object/public/images/city/Dordogne/city_dordogne_tablet.webp'
        : 'https://hxrlnebwhznskjhzkjit.supabase.co/storage/v1/object/public/images/city/Dordogne/city_dordogne_mobile.webp';

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Image de background (MANQUAIT !)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              cacheKey: 'city_cover_${screenWidth > 600 ? 'tablet' : 'mobile'}',
              placeholder: (context, url) => Container(
                color: isDark ? AppColors.primaryDark : AppColors.primary,
              ),
              errorWidget: (context, url, error) => Container(
                color: isDark ? AppColors.primaryDark : AppColors.primary,
              ),
            ),
          ),

          // 2. Filtre primary à 90% d'opacité
          Positioned.fill(
            child: Container(
              color: (isDark ? AppColors.primaryDark : AppColors.primary).withOpacity(0.95),
            ),
          ),

          // 3. Contenu (aligné en bas avec padding 50px)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 24.0,
                bottom: 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cityName,
                    style: AppTypography.titleL(isDark: false).copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: AppTypography.body(isDark: false).copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      children: [
                        TextSpan(text: 'Nous avons sélectionné pour vous '),
                        TextSpan(
                          text: '$activityCount activités', // ✅ NOMBRE + MOT EN BOLD
                          style: AppTypography.body(isDark: false).copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' à $cityName et ses alentours.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant CityPageCoverDelegate oldDelegate) {
    return oldDelegate.cityName != cityName ||
        oldDelegate.activityCount != activityCount ||
        oldDelegate.screenWidth != screenWidth;
  }
}