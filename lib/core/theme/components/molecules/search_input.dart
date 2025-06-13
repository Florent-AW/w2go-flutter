// lib/core/theme/components/molecules/search_input.dart

import 'package:flutter/material.dart';
import '../atoms/app_text_field.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onClearPressed;
  final bool showClearButton;

  const SearchInput({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onChanged,
    this.onSubmitted,
    this.onClearPressed,
    this.showClearButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Bouton de nettoyage si nécessaire
    final Widget? clearButton = showClearButton && onClearPressed != null
        ? IconButton(
      icon: const Icon(Icons.clear, size: 20),
      onPressed: onClearPressed,
    )
        : null;

    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      suffixIcon: clearButton,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
    );
  }
}