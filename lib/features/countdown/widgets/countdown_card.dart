import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../models/countdown_item.dart';

class CountdownCard extends StatelessWidget {
  final CountdownItem item;
  final DateTime now;

  const CountdownCard({
    super.key,
    required this.item,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final remaining = item.remaining;
    final prog = item.progress(now);
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    final isPast = remaining.isNegative;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            item.color.withValues(alpha: 0.15),
            isDark ? AppColors.slate900 : Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: item.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocale.format(item.title),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.slate800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isPast)
              Text(
                'Event passed',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.slate500,
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TimeSegment(
                    value: days,
                    label: AppLocale.format(AppLocale.countdownDays),
                    color: item.color,
                  ),
                  _Separator(color: item.color),
                  _TimeSegment(
                    value: hours,
                    label: AppLocale.format(AppLocale.countdownHours),
                    color: item.color,
                  ),
                  _Separator(color: item.color),
                  _TimeSegment(
                    value: minutes,
                    label: AppLocale.format(AppLocale.countdownMinutes),
                    color: item.color,
                  ),
                  _Separator(color: item.color),
                  _TimeSegment(
                    value: seconds,
                    label: AppLocale.format(AppLocale.countdownSeconds),
                    color: item.color,
                  ),
                ],
              ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: isPast ? 1.0 : prog,
                backgroundColor: isDark ? AppColors.slate700 : AppColors.slate200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  item.color.withValues(alpha: 0.7),
                ),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeSegment extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const _TimeSegment({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _Separator extends StatelessWidget {
  final Color color;

  const _Separator({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
