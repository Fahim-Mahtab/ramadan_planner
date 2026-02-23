import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/custom_card.dart';

/// Asmaul Husna (Names of Allah) card widget
class AsmaulHusnaCard extends StatelessWidget {
  const AsmaulHusnaCard({super.key});

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
                AppConstants.asmaulHusna,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '1 of 99',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.slate400 : AppColors.slate400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Content row
          Row(
            children: [
              // Circular badge with Arabic name
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
                    'الرَّحْمَنُ',
                    style: AppTheme.arabicTextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: AppColors.gold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Name and meaning
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ar-Rahman',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.slate800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'The Most Gracious / পরম দয়ালু',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.slate400 : AppColors.slate500,
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
  }
}
