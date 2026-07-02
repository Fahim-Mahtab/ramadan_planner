import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/qibla_provider.dart';

class BearingDisplay extends StatelessWidget {
  const BearingDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QiblaProvider>(
      builder: (context, provider, _) {
        final dir = provider.direction;
        if (dir == null) return const SizedBox.shrink();

        final isDark = context.isDark;
        final deviation = (dir.bearing % 360) > 355 || (dir.bearing % 360) < 5;

        return Column(
          children: [
            Text(
              dir.bearingLabel,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.slate800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
               AppLocale.format(AppLocale.qiblaBearing, replace: {'dir': dir.cardinalDirection}),
              style: TextStyle(
                fontSize: 18,
                color: isDark ? AppColors.slate300 : AppColors.slate600,
              ),
            ),
            if (deviation)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        AppLocale.format(AppLocale.qiblaFacing),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
