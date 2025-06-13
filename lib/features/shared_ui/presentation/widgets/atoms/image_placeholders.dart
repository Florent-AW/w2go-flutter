// lib/features/shared_ui/presentation/widgets/atoms/image_placeholders.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class LoadingImagePlaceholder extends StatelessWidget {
  final double? height;
  final double? width;

  const LoadingImagePlaceholder({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: AppColors.neutral200,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class ErrorImagePlaceholder extends StatelessWidget {
  final double? height;
  final double? width;

  const ErrorImagePlaceholder({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: AppColors.neutral200,
      child: const Center(
        child: Icon(Icons.error_outline),
      ),
    );
  }
}

class EmptyImagePlaceholder extends StatelessWidget {
  final double? height;
  final double? width;

  const EmptyImagePlaceholder({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: AppColors.neutral200,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined),
      ),
    );
  }
}