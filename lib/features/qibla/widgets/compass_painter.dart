import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CompassPainter extends CustomPainter {
  final double bearing;
  final bool isDark;

  CompassPainter({required this.bearing, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 24;

    _drawOuterRing(canvas, center, radius);
    _drawCardinalMarkers(canvas, center, radius);
    _drawNeedle(canvas, center, radius);
  }

  void _drawOuterRing(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = isDark ? AppColors.slate800 : AppColors.slate100
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, paint);
  }

  void _drawCardinalMarkers(Canvas canvas, Offset center, double radius) {
    for (var i = 0; i < 72; i++) {
      final angle = (i * 5 * pi / 180) - (bearing * pi / 180);
      final isMajor = i % 18 == 0;
      final isMedium = i % 9 == 0;
      final length = isMajor ? 16.0 : (isMedium ? 10.0 : 6.0);
      final innerR = radius - (isMajor ? 24 : (isMedium ? 18 : 14));

      final x1 = center.dx + innerR * cos(angle);
      final y1 = center.dy + innerR * sin(angle);
      final x2 = center.dx + (innerR + length) * cos(angle);
      final y2 = center.dy + (innerR + length) * sin(angle);

      final paint = Paint()
        ..color = isMajor
            ? Colors.white
            : (isDark ? AppColors.slate500 : AppColors.slate400)
        ..strokeWidth = isMajor ? 2.5 : 1.5;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

      if (isMajor) {
        _drawLabel(canvas, center, radius - 32, angle, _cardinalLabel(i ~/ 18));
      }
    }
  }

  String _cardinalLabel(int index) => switch (index) {
        0 => 'N',
        1 => 'E',
        2 => 'S',
        3 => 'W',
        _ => '',
      };

  void _drawLabel(Canvas canvas, Offset center, double r, double angle, String label) {
    final x = center.dx + r * cos(angle);
    final y = center.dy + r * sin(angle);
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: label == 'N' ? AppColors.warning : AppColors.primary,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
  }

  void _drawNeedle(Canvas canvas, Offset center, double radius) {
    final northPaint = Paint()
      ..color = AppColors.warning
      ..style = PaintingStyle.fill;

    final southPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(center.dx, center.dy - radius + 20)
      ..lineTo(center.dx - 8, center.dy + 8)
      ..lineTo(center.dx, center.dy - 4)
      ..lineTo(center.dx + 8, center.dy + 8)
      ..close();

    canvas.drawPath(path, northPaint);

    final southPath = Path()
      ..moveTo(center.dx, center.dy + radius - 20)
      ..lineTo(center.dx - 8, center.dy - 8)
      ..lineTo(center.dx, center.dy + 4)
      ..lineTo(center.dx + 8, center.dy - 8)
      ..close();

    canvas.drawPath(southPath, southPaint);

    final centerPaint = Paint()
      ..color = isDark ? Colors.white : AppColors.slate800
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CompassPainter old) => old.bearing != bearing;
}
