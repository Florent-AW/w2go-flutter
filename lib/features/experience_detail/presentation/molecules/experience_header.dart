// lib/features/experience_detail/presentation/molecules/experience_header.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/components/atoms/circle_back_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../atoms/hero_image.dart';
import '../atoms/carousel_indicator.dart';

/// ✅ MOLECULE : Header responsable uniquement de l'affichage d'images
class ExperienceHeader extends StatefulWidget {
  final List<String> imageUrls;
  final String heroTag;
  final String experienceId;
  final VoidCallback onDismiss;

  const ExperienceHeader({
    Key? key,
    required this.imageUrls,
    required this.heroTag,
    required this.experienceId,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<ExperienceHeader> createState() => _ExperienceHeaderState();
}

class _ExperienceHeaderState extends State<ExperienceHeader> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ATOMIC : Une seule image = Hero simple
    if (widget.imageUrls.length <= 1) {
      return _buildSingleImage();
    }

    // ✅ ATOMIC : Plusieurs images = carousel avec Hero sur la première
    return _buildImageCarousel();
  }

  Widget _buildSingleImage() {
    return Container(
      height: 400,
      child: Stack(
        children: [
          // ✅ ATOM : Hero Image
          Positioned.fill(
            child: HeroImage(
              tag: widget.heroTag,
              url: widget.imageUrls.first,
              fit: BoxFit.cover,
            ),
          ),

          // ✅ ATOM : Back button
          _buildBackButton(),

          // ✅ ATOM : Swipe dismiss detector
          _buildSwipeDismissDetector(),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Container(
      height: 400,
      child: Stack(
        children: [
          // ✅ PageView avec Hero sur première image
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              if (mounted) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              final isFirst = index == 0;
              final imageUrl = widget.imageUrls[index];

              // ✅ ATOM : Hero seulement sur première image
              return HeroMode(
                enabled: isFirst,
                child: isFirst
                    ? HeroImage(
                  tag: widget.heroTag,
                  url: imageUrl,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  gaplessPlayback: true,
                ),
              );
            },
          ),

          // ✅ ATOM : Indicateurs
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: CarouselIndicator(
                itemCount: widget.imageUrls.length,
                currentIndex: _currentIndex,
              ),
            ),

          // ✅ ATOM : Back button
          _buildBackButton(),

          // ✅ ATOM : Swipe dismiss detector
          _buildSwipeDismissDetector(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleBackButton(
            onPressed: widget.onDismiss,
            backgroundColor: Colors.white,
            iconColor: AppColors.primary,
            size: 38,
            iconSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeDismissDetector() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 60,
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 300) {
            widget.onDismiss();
          }
        },
        child: Center(
          child: Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        ),
      ),
    );
  }
}