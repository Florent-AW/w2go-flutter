// lib/core/theme/components/atoms/app_text_field.dart

import 'package:flutter/material.dart';
import '../../app_typography.dart';
import '../../extensions/text_field_tokens.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final TextFieldTokens tokens = Theme.of(context).extension<TextFieldTokens>() ??
        (isDark ? TextFieldTokens.dark() : TextFieldTokens.light());

    return Semantics(
      textField: true,
      label: hintText,
      child: Container(
        decoration: BoxDecoration(
          color: tokens.fillColor,
          borderRadius: BorderRadius.circular(tokens.borderRadius),
          boxShadow: [tokens.boxShadow],
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          style: AppTypography.body(isDark: isDark),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.body(isDark: isDark).copyWith(
              color: tokens.hintTextColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.borderRadius),
              borderSide: BorderSide(color: tokens.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.borderRadius),
              borderSide: BorderSide(color: tokens.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.borderRadius),
              borderSide: BorderSide(color: tokens.focusedBorderColor),
            ),
            contentPadding: tokens.contentPadding,
            suffixIcon: suffixIcon,
          ),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
        ),
      ),
    );
  }
}