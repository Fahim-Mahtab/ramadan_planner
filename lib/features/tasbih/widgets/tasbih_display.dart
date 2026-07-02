import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/tasbih_provider.dart';

class TasbihDisplay extends StatelessWidget {
  const TasbihDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasbihProvider>(
      builder: (context, provider, _) {
        final current = provider.records[provider.selectedIndex];
        final progress = current.progress.clamp(0.0, 1.0);
        final isDark = context.isDark;
        final remaining = current.target - current.count;

        return GestureDetector(
          onTap: provider.increment,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.slate800 : AppColors.slate50,
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: AppColors.primary.withAlpha(25),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
              ],
            ),
            child: CustomPaint(
              painter: _CircularProgressPainter(
                progress: progress,
                isDark: isDark,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${current.count}',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.slate800,
                      ),
                    ),
                    Text(
                      '/ ${current.target}',
                      style: TextStyle(
                        fontSize: 20,
                        color: isDark ? AppColors.slate400 : AppColors.slate500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      remaining > 0 ? AppLocale.format(AppLocale.tasbihRemaining, replace: {'count': '$remaining'}) : AppLocale.format(AppLocale.tasbihCompleted),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: remaining > 0
                            ? (isDark ? AppColors.slate400 : AppColors.slate500)
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _CircularProgressPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;

    final bgPaint = Paint()
      ..color = isDark ? AppColors.slate700 : AppColors.slate200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter old) => old.progress != progress;
}
