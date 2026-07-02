import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';

class FastingLegend extends StatelessWidget {
  const FastingLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textStyle = TextStyle(
      fontSize: 11,
      color: isDark ? AppColors.slate400 : AppColors.slate500,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendDot(color: AppColors.primary),
        const SizedBox(width: 4),
        Text(AppLocale.format(AppLocale.fastingLegendKept), style: textStyle),
        const SizedBox(width: 16),
        _LegendDot(color: AppColors.warning),
        const SizedBox(width: 4),
        Text(AppLocale.format(AppLocale.fastingLegendMissed), style: textStyle),
        const SizedBox(width: 16),
        _LegendDot(color: AppColors.gold),
        const SizedBox(width: 4),
        Text(AppLocale.format(AppLocale.fastingLegendRecommended), style: textStyle),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
