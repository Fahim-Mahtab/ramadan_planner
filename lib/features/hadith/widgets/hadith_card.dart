import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../shared/widgets/custom_card.dart';
import '../providers/hadith_provider.dart';

class HadithCard extends StatelessWidget {
  const HadithCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HadithProvider>(
      builder: (context, provider, _) {
        final hadith = provider.hadithOfTheDay;
        final isDark = context.isDark;

        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocale.format(AppLocale.hadithCardTitle),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      AppLocale.format(AppLocale.hadithNumber, replace: {'number': '${hadith.number}'}),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (hadith.arabic.isNotEmpty) ...[
                Text(
                  hadith.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTheme.arabicTextStyle(
                    fontSize: 20,
                    color: isDark ? Colors.white : AppColors.slate800,
                  ).copyWith(height: 1.8),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                hadith.textEn,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.slate300 : AppColors.slate700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '— ${hadith.sourceEn}',
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: isDark ? AppColors.slate500 : AppColors.slate400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
