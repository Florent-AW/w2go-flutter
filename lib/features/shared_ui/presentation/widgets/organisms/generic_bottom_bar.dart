// lib/features/shared_ui/presentation/widgets/organisms/generic_bottom_bar.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/components/molecules/bottom_bar_wrapper.dart';
import '../molecules/navigation_buttons_row.dart';

export '../molecules/navigation_buttons_row.dart' show BottomNavTab;


/// Bottom bar générique avec navigation 4 tabs
/// Organisme qui combine BottomBarWrapper + NavigationButtonsRow
class GenericBottomBar extends StatelessWidget {
  final BottomNavTab selectedTab;
  final Function(BottomNavTab) onTabSelected;
  final bool isLoading;
  final EdgeInsets? customPadding;

  const GenericBottomBar({
    Key? key,
    this.selectedTab = BottomNavTab.explorer,
    required this.onTabSelected,
    this.isLoading = false,
    this.customPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomBarWrapper(
      content: NavigationButtonsRow(
        selectedTab: selectedTab,
        onTabSelected: onTabSelected,
      ),
      isLoading: isLoading,
      customPadding: customPadding,
    );
  }
}