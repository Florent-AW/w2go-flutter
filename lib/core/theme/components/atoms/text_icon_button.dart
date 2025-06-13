// lib/core/theme/components/atoms/text_icon_button.dart

import 'package:flutter/material.dart';
import '../../app_typography.dart';
import '../../extensions/action_tokens.dart';

class TextIconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool iconLeading; // Si true, l'icône est avant le texte

  const TextIconButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.iconLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ActionTokens tokens = Theme.of(context).extension<ActionTokens>() ??
        (isDark ? ActionTokens.dark() : ActionTokens.light());

    return Semantics(
      button: true,
      label: text,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: tokens.padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: iconLeading
                  ? _buildLeadingLayout(context, tokens)
                  : _buildTrailingLayout(context, tokens),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLeadingLayout(BuildContext context, ActionTokens tokens) {
    return [
      Icon(
        icon,
        color: tokens.iconColor,
        size: tokens.iconSize,
      ),
      const SizedBox(width: 8),
      Text(
        text,
        style: AppTypography.body(
          isDark: Theme.of(context).brightness == Brightness.dark,
        ).copyWith(
          color: tokens.textColor,
          decoration: tokens.textDecoration,
        ),
      ),
    ];
  }

  List<Widget> _buildTrailingLayout(BuildContext context, ActionTokens tokens) {
    return [
      Text(
        text,
        style: AppTypography.body(
          isDark: Theme.of(context).brightness == Brightness.dark,
        ).copyWith(
          color: tokens.textColor,
          decoration: tokens.textDecoration,
        ),
      ),
      const SizedBox(width: 8),
      Icon(
        icon,
        color: tokens.iconColor,
        size: tokens.iconSize,
      ),
    ];
  }
}