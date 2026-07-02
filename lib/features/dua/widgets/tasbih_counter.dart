import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';

class TasbihCounter extends StatelessWidget {
  final int count;
  final int target;
  final VoidCallback onTap;
  final VoidCallback onReset;

  const TasbihCounter({
    super.key,
    required this.count,
    required this.target,
    required this.onTap,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = target > 0 ? (count / target).clamp(0.0, 1.0) : 0.0;
    final isComplete = count >= target;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(Icons.loop_rounded,
                  size: 16,
                  color: isDark ? AppColors.slate400 : AppColors.slate500),
              const SizedBox(width: 6),
              Text(
                AppLocale.format(AppLocale.tasbihCounterTitle),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: isDark ? AppColors.slate400 : AppColors.slate500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    strokeCap: StrokeCap.round,
                    backgroundColor: isDark
                        ? AppColors.slate700
                        : AppColors.slate100,
                    valueColor: AlwaysStoppedAnimation(
                      isComplete ? AppColors.gold : AppColors.primary,
                    ),
                  ),
                ),
                Container(
                  width: 116,
                  height: 116,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? AppColors.emerald900.withValues(alpha: 0.3)
                        : const Color(0xFFECFDF5),
                    boxShadow: [
                      BoxShadow(
                        color: (isComplete ? AppColors.gold : AppColors.primary)
                            .withValues(alpha: 0.15),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Text(
                          '$count',
                          key: ValueKey(count),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: isComplete
                                ? AppColors.gold
                                : AppColors.primary,
                          ),
                        ),
                      ),
                      Text(
                        '/ $target',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.slate400
                              : AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isComplete)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 14, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text(
                      AppLocale.format(AppLocale.tasbihCounterCompleted),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onReset,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.slate800
                      : AppColors.slate100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded,
                        size: 14,
                        color:
                            isDark ? AppColors.slate400 : AppColors.slate500),
                    const SizedBox(width: 4),
                    Text(
                      AppLocale.format(AppLocale.tasbihCounterReset),
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isDark ? AppColors.slate400 : AppColors.slate500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          AppLocale.format(AppLocale.tasbihCounterTapHint),
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.slate500 : AppColors.slate400,
          ),
        ),
      ],
    );
  }
}
