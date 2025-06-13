// lib/features/shared_ui/presentation/widgets/molecules/activity_card_header.dart

import 'package:flutter/material.dart';
import '../atoms/activity_image.dart';
import '../atoms/activity_favorite_button.dart';

class ActivityCardHeader extends StatelessWidget {
  final String imageUrl;
  final double height;
  final bool isFavorite;
  final VoidCallback? onFavoritePress;
  final String heroTag;              // ✅ Obligatoire et simple

  const ActivityCardHeader({
    Key? key,
    required this.imageUrl,
    required this.height,
    this.isFavorite = false,
    this.onFavoritePress,
    required this.heroTag,           // ✅ Obligatoire
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ActivityImage(
          imageUrl: imageUrl,
          height: height,
          heroTag: heroTag,            // ✅ Utilise directement
        ),
        Positioned(
          top: 4,
          right: 4,
          child: ActivityFavoriteButton(
            isFavorite: isFavorite,
            onPressed: onFavoritePress,
          ),
        ),
      ],
    );
  }
}