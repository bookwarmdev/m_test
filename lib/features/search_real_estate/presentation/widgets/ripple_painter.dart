import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class RipplePainter extends CustomPainter {
  final double radius;
  final double? strokeWidth;
  final Color color;
  final double opacity;
  final bool fadeOut;
  final Paint _paint;

  RipplePainter(
    this.radius, {
    this.strokeWidth,
    this.color = Colors.white,
    this.opacity = 0.9,
    this.fadeOut = true,
  }) : _paint =
           Paint()
             ..color = color.withValues(
               alpha:
                   fadeOut
                       ? (opacity * (1 - radius / 100).clamp(0.0, 1.0))
                       : opacity,
             )
             ..style = PaintingStyle.stroke
             ..strokeWidth = strokeWidth ?? 5
             ..strokeCap = StrokeCap.round
             ..maskFilter = ui.MaskFilter.blur(
               BlurStyle.normal,
               (strokeWidth ?? 5) * 0.4,
             );
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, _paint);

    if (radius > 2) {
      final innerPaint =
          Paint()
            ..color = color.withValues(alpha: opacity * 0.7)
            ..style = PaintingStyle.stroke
            ..strokeWidth = (strokeWidth ?? 5) * 0.6;

      canvas.drawCircle(center, radius * 0.85, innerPaint);
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color ||
        oldDelegate.opacity != opacity;
  }
}
