import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/prayer_times_provider.dart';
import '../models/prayer_times_model.dart';

class PrayerClockWidget extends StatefulWidget {
  const PrayerClockWidget({super.key});

  @override
  State<PrayerClockWidget> createState() => _PrayerClockWidgetState();
}

class _PrayerClockWidgetState extends State<PrayerClockWidget> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<PrayerTimesProvider>(
      builder: (context, provider, _) {
        final data = provider.prayerTimes;
        if (data == null) return const SizedBox.shrink();

        final periods = _buildPeriods(data);
        final nowMinutes = _now.hour * 60 + _now.minute;
        final current = _findCurrentPeriod(periods, nowMinutes);
        final next = _findNextPrayer(periods, nowMinutes);

        return Column(
          children: [
            Container(
              width: 230,
              height: 230,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.slate800 : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: (current?.color ?? AppColors.primary)
                        .withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: CustomPaint(
                painter: _PrayerClockPainter(
                  periods: periods,
                  now: _now,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (next != null) _buildNextPrayerText(next, nowMinutes, isDark),
            if (current != null) ...[
              const SizedBox(height: 4),
              _buildCurrentPrayerText(current, isDark),
            ],
          ],
        );
      },
    );
  }

  Widget _buildNextPrayerText(
      _PrayerPeriod next, int nowMinutes, bool isDark) {
    int diff = next.startMinutes - nowMinutes;
    if (diff <= 0) diff += 1440;
    final h = diff ~/ 60;
    final m = diff % 60;

    final timeStr = h > 0 ? '$hঘ $mমি' : '$mমি';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: next.color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'পরবর্তী: ${next.banglaName}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.slate700,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '• $timeStr',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: next.color,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentPrayerText(_PrayerPeriod current, bool isDark) {
    return Text(
      'বর্তমান: ${current.banglaName}',
      style: TextStyle(
        fontSize: 12,
        color: isDark ? AppColors.slate400 : AppColors.slate500,
      ),
    );
  }

  List<_PrayerPeriod> _buildPeriods(PrayerTimesModel data) {
    final times = [
      ('Fajr', 'ফজর', _parseMinutes(data.fajr), const Color(0xFF3B82F6)),
      ('Sunrise', 'সূর্যোদয়', _parseMinutes(data.sunrise),
          const Color(0xFFF59E0B)),
      ('Dhuhr', 'যোহর', _parseMinutes(data.dhuhr), const Color(0xFF10B981)),
      ('Asr', 'আসর', _parseMinutes(data.asr), const Color(0xFFF97316)),
      ('Maghrib', 'মাগরিব', _parseMinutes(data.maghrib),
          const Color(0xFFD4AF37)),
      ('Isha', 'ইশা', _parseMinutes(data.isha), const Color(0xFF6366F1)),
    ];

    final nowMin = _now.hour * 60 + _now.minute;
    final periods = <_PrayerPeriod>[];

    for (int i = 0; i < times.length; i++) {
      final (name, bangla, startMin, color) = times[i];
      final nextIndex = (i + 1) % times.length;
      final endMin = times[nextIndex].$3;

      int sweep = endMin - startMin;
      if (sweep <= 0) sweep += 1440;

      bool isActive;
      if (startMin <= endMin) {
        isActive = nowMin >= startMin && nowMin < endMin;
      } else {
        isActive = nowMin >= startMin || nowMin < endMin;
      }

      periods.add(_PrayerPeriod(
        name: name,
        banglaName: bangla,
        color: color,
        startMinutes: startMin,
        sweepMinutes: sweep,
        startAngle: _minutesToRadians(startMin),
        sweepAngle: (sweep / 1440.0) * 2 * pi,
        isActive: isActive,
      ));
    }

    return periods;
  }

  _PrayerPeriod? _findCurrentPeriod(
      List<_PrayerPeriod> periods, int nowMinutes) {
    for (final p in periods) {
      if (p.isActive) return p;
    }
    return null;
  }

  _PrayerPeriod? _findNextPrayer(
      List<_PrayerPeriod> periods, int nowMinutes) {
    final currentIndex = periods.indexWhere((p) => p.isActive);
    if (currentIndex == -1) return null;
    return periods[(currentIndex + 1) % periods.length];
  }

  static int _parseMinutes(String timeStr) {
    try {
      final raw = timeStr.split(' ').first;
      final parts = raw.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    } catch (_) {
      return 0;
    }
  }

  static double _minutesToRadians(int minutes) {
    return (minutes / 1440.0) * 2 * pi - pi / 2;
  }
}

class _PrayerPeriod {
  final String name;
  final String banglaName;
  final Color color;
  final int startMinutes;
  final int sweepMinutes;
  final double startAngle;
  final double sweepAngle;
  final bool isActive;

  const _PrayerPeriod({
    required this.name,
    required this.banglaName,
    required this.color,
    required this.startMinutes,
    required this.sweepMinutes,
    required this.startAngle,
    required this.sweepAngle,
    required this.isActive,
  });
}

class _PrayerClockPainter extends CustomPainter {
  final List<_PrayerPeriod> periods;
  final DateTime now;
  final bool isDark;

  _PrayerClockPainter({
    required this.periods,
    required this.now,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    _drawClockFace(canvas, center, radius);
    _drawPrayerArcs(canvas, center, radius);
    _drawHourMarkers(canvas, center, radius);
    _drawCurrentTimeDot(canvas, center, radius);
    _drawClockHands(canvas, center, radius);
    _drawCenterDot(canvas, center);
  }

  void _drawClockFace(Canvas canvas, Offset center, double radius) {
    final facePaint = Paint()
      ..color = isDark ? AppColors.slate800 : Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 14, facePaint);

    final borderPaint = Paint()
      ..color = isDark
          ? AppColors.slate700.withValues(alpha: 0.5)
          : AppColors.slate300.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius - 14, borderPaint);
  }

  void _drawPrayerArcs(Canvas canvas, Offset center, double radius) {
    final arcRadius = radius - 7;
    final rect = Rect.fromCircle(center: center, radius: arcRadius);

    for (final period in periods) {
      final paint = Paint()
        ..color = period.color
            .withValues(alpha: period.isActive ? 1.0 : (isDark ? 0.35 : 0.25))
        ..style = PaintingStyle.stroke
        ..strokeWidth = period.isActive ? 14 : 10
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, period.startAngle, period.sweepAngle, false, paint);
    }

    final activePeriod = periods.where((p) => p.isActive).firstOrNull;
    if (activePeriod != null) {
      final glowPaint = Paint()
        ..color = activePeriod.color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.butt
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawArc(
          rect, activePeriod.startAngle, activePeriod.sweepAngle, false,
          glowPaint);
    }
  }

  void _drawHourMarkers(Canvas canvas, Offset center, double radius) {
    final tickRadius = radius - 14;
    final markerColor =
        isDark ? AppColors.slate500 : AppColors.slate400;

    for (int i = 0; i < 24; i++) {
      final angle = (i / 24.0) * 2 * pi - pi / 2;
      final isMajor = i % 6 == 0;
      final tickLen = isMajor ? 8.0 : 4.0;

      final outerPoint = Offset(
        center.dx + (tickRadius) * cos(angle),
        center.dy + (tickRadius) * sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (tickRadius - tickLen) * cos(angle),
        center.dy + (tickRadius - tickLen) * sin(angle),
      );

      final tickPaint = Paint()
        ..color = markerColor.withValues(alpha: isMajor ? 0.8 : 0.4)
        ..strokeWidth = isMajor ? 2 : 1
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(innerPoint, outerPoint, tickPaint);

      if (isMajor) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '$i',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: markerColor,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final labelRadius = tickRadius - tickLen - 10;
        final labelOffset = Offset(
          center.dx + labelRadius * cos(angle) - textPainter.width / 2,
          center.dy + labelRadius * sin(angle) - textPainter.height / 2,
        );
        textPainter.paint(canvas, labelOffset);
      }
    }
  }

  void _drawCurrentTimeDot(Canvas canvas, Offset center, double radius) {
    final nowMinutes = now.hour * 60 + now.minute;
    final angle = (nowMinutes / 1440.0) * 2 * pi - pi / 2;
    final dotRadius = radius - 7;

    final dotCenter = Offset(
      center.dx + dotRadius * cos(angle),
      center.dy + dotRadius * sin(angle),
    );

    final glowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(dotCenter, 7, glowPaint);

    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(dotCenter, 5, dotPaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(dotCenter, 5, borderPaint);
  }

  void _drawClockHands(Canvas canvas, Offset center, double radius) {
    final handColor = isDark ? AppColors.slate300 : AppColors.slate700;
    final innerRadius = radius - 22;

    // Hour hand (24-hour, one rotation = 24 hours)
    final hourAngle =
        ((now.hour + now.minute / 60.0) / 24.0) * 2 * pi - pi / 2;
    _drawHand(
      canvas, center, hourAngle,
      length: innerRadius * 0.45,
      width: 3.5,
      color: handColor,
    );

    // Minute hand
    final minuteAngle =
        ((now.minute + now.second / 60.0) / 60.0) * 2 * pi - pi / 2;
    _drawHand(
      canvas, center, minuteAngle,
      length: innerRadius * 0.65,
      width: 2.5,
      color: handColor,
    );

    // Second hand
    final secondAngle = (now.second / 60.0) * 2 * pi - pi / 2;
    _drawHand(
      canvas, center, secondAngle,
      length: innerRadius * 0.75,
      width: 1.2,
      color: AppColors.primary,
    );
  }

  void _drawHand(
    Canvas canvas,
    Offset center,
    double angle, {
    required double length,
    required double width,
    required Color color,
  }) {
    final end = Offset(
      center.dx + length * cos(angle),
      center.dy + length * sin(angle),
    );
    final tail = Offset(
      center.dx - 8 * cos(angle),
      center.dy - 8 * sin(angle),
    );

    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(tail, end, paint);
  }

  void _drawCenterDot(Canvas canvas, Offset center) {
    canvas.drawCircle(
      center,
      5,
      Paint()..color = AppColors.primary,
    );
    canvas.drawCircle(
      center,
      2.5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _PrayerClockPainter oldDelegate) {
    return oldDelegate.now.second != now.second || oldDelegate.isDark != isDark;
  }
}
