import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/fasting_provider.dart';

class FastingStats extends StatelessWidget {
  const FastingStats({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final provider = context.watch<FastingProvider>();

    return Row(
      children: [
        _StatCard(
          label: AppLocale.format(AppLocale.fastingThisMonth),
          value: '${provider.currentMonthFasts}',
          icon: Icons.calendar_month_rounded,
          color: AppColors.primary,
          isDark: isDark,
        ),
        const SizedBox(width: 12),
        _StatCard(
          label: AppLocale.format(AppLocale.fastingStreak),
          value: '${provider.currentStreak}',
          icon: Icons.local_fire_department_rounded,
          color: AppColors.gold,
          isDark: isDark,
        ),
        const SizedBox(width: 12),
        _StatCard(
          label: AppLocale.format(AppLocale.fastingThisYear),
          value: '${provider.totalFastsThisYear}',
          icon: Icons.trending_up_rounded,
          color: AppColors.emerald600,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withAlpha(40),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.slate800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.slate400 : AppColors.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
