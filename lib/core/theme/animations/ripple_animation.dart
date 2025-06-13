// lib/core/theme/animations/ripple_animation.dart

import 'package:flutter/material.dart';

class RippleAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? rippleColor;
  final Duration duration;

  const RippleAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
    });
  }

  void _handleTap() {
    if (_tapPosition != null) {
      _controller.forward(from: 0.0);
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTap: _handleTap,
      child: Stack(
        children: [
          widget.child,
          if (_tapPosition != null)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: CircleRipplePainter(
                    position: _tapPosition!,
                    progress: _animation.value,
                    color: widget.rippleColor ?? Colors.white.withAlpha(50),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class CircleRipplePainter extends CustomPainter {
  final Offset position;
  final double progress;
  final Color color;

  CircleRipplePainter({
    required this.position,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxRadius = size.longestSide * 1.5;  // L'onde dépasse le widget
    final Paint paint = Paint()
      ..color = color.withOpacity(1 - progress)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      position,
      maxRadius * progress,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircleRipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}