import 'package:flutter/material.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/custom_card.dart';

/// Ayah of the Day card widget
class AyahCard extends StatelessWidget {
  const AyahCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocale.format(AppLocale.ayahTitle).toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.share_rounded,
                  color: AppColors.gold,
                  size: 20,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocale.format(AppLocale.noticeShareComingSoon)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Arabic text
          Text(
            AppLocale.format(AppLocale.ayahText),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTheme.arabicTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white : AppColors.slate800,
            ).copyWith(height: 1.8),
          ),
          const SizedBox(height: 16),
          // Translation
          Text(
            AppLocale.format(AppLocale.ayahTranslation),
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.slate300 : AppColors.slate600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          // Reference
          Text(
            AppLocale.format(AppLocale.ayahReference),
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.slate500 : AppColors.slate400,
            ),
          ),
        ],
      ),
    );
  }
}
