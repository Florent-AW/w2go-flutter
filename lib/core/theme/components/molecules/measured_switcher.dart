// lib/core/theme/components/molecules/measured_switcher.dart
import 'package:flutter/material.dart';

class MeasuredSwitcher extends StatefulWidget {
  const MeasuredSwitcher({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 220),
  }) : super(key: key);

  final Widget child;
  final Duration duration;

  @override
  State<MeasuredSwitcher> createState() => _MeasuredSwitcherState();
}

class _MeasuredSwitcherState extends State<MeasuredSwitcher> {
  double _minHeight = 0;

  void _updateHeight() {
    final rb = context.findRenderObject() as RenderBox?;
    if (rb != null && mounted) {
      final h = rb.size.height;
      if ((h - _minHeight).abs() > 0.5) {
        setState(() => _minHeight = h);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeight());

    return AnimatedSize(
      duration: widget.duration,
      curve: Curves.easeInOut,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: _minHeight),
        child: AnimatedSwitcher(
          duration: widget.duration,
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          layoutBuilder: (child, _) => child!,  // Évite le Stack implicite
          child: widget.child,
        ),
      ),
    );
  }
}