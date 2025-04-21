import 'package:flutter/material.dart';

import '../../../search_real_estate/presentation/widgets/ripple_painter.dart';

class NavIcon extends StatelessWidget {
  final VoidCallback onClick;
  final double height;
  final double width;
  final Decoration decoration;
  final bool isClicked;
  final Widget child;
  final double strokeWidth;
  final AnimationController controller;
  final bool isStrokeVisible;

  const NavIcon({
    super.key,
    required this.onClick,
    required this.height,
    required this.width,
    required this.decoration,
    required this.child,
    this.isClicked = false,
    this.strokeWidth = 1.0,
    required this.controller,
    this.isStrokeVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.circle,
      onTap: onClick,
      splashColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        decoration: decoration,
        child:
            isClicked
                ? _RippleEffect(
                  strokeWidth: strokeWidth,
                  controller: controller,
                  isCustomPaintVisible: isStrokeVisible,
                  child: child,
                )
                : child,
      ),
    );
  }
}

class _RippleEffect extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final AnimationController controller;
  final bool isCustomPaintVisible;

  const _RippleEffect({
    required this.child,
    required this.strokeWidth,
    required this.controller,
    required this.isCustomPaintVisible,
  });

  @override
  Widget build(BuildContext context) {
    final rippleAnimation = Tween<double>(
      begin: 28,
      end: 20,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    return AnimatedBuilder(
      animation: rippleAnimation,
      builder:
          (_, __) => Center(
            child: CustomPaint(
              painter:
                  isCustomPaintVisible
                      ? RipplePainter(
                        rippleAnimation.value,
                        strokeWidth: strokeWidth,
                      )
                      : null,
              child: child,
            ),
          ),
    );
  }
}
