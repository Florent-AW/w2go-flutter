// lib/core/theme/components/atoms/selection_button.dart

import 'package:flutter/material.dart';
import '../../app_typography.dart';
import '../../extensions/selection_tokens.dart';

class SelectionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  final IconData? leadingIcon;

  const SelectionButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.leadingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final SelectionTokens tokens = Theme.of(context).extension<SelectionTokens>() ??
        (isDark ? SelectionTokens.dark() : SelectionTokens.light());

    final selectionState = isSelected ? SelectionState.selected : SelectionState.unselected;

    return Semantics(
      button: true,
      selected: isSelected,
      value: text,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            height: tokens.height,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: tokens.backgroundColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                // Leading Icon
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    size: 24,
                    color: tokens.iconColors[selectionState],
                  ),
                  const SizedBox(width: 8),
                ],

                // Text
                Expanded(
                  child: Text(
                    text,
                    style: AppTypography.body(
                      isDark: isDark,
                    ).copyWith(
                      color: tokens.textColors[selectionState],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Dropdown Icon
                Icon(
                  Icons.keyboard_arrow_down,
                  color: tokens.dropdownIconColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}