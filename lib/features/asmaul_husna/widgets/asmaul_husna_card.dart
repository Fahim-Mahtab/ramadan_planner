import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/custom_card.dart';
import '../providers/asmaul_husna_provider.dart';

class AsmaulHusnaCard extends StatelessWidget {
  const AsmaulHusnaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AsmaulHusnaProvider>(
      builder: (context, provider, _) {
        final name = provider.nameOfTheDay;

        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocale.format(AppLocale.asmaulHusnaTitle),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${name.number} ${AppLocale.format(AppLocale.asmaulHusnaOf)} 99',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AppColors.slate400 : AppColors.slate400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        name.arabic,
                        style: AppTheme.arabicTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: AppColors.gold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.transliteration,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.slate800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name.meaning,
                          style: TextStyle(
                            fontSize: 12,
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
            ],
          ),
        );
      },
    );
  }
}
