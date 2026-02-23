import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

/// Dua of the Day card widget
class DuaCard extends StatelessWidget {
  const DuaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.emerald900.withValues(alpha: 0.2)
            : const Color(0xFFECFDF5), // emerald-50
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: AppColors.gold, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                AppConstants.duaOfTheDay.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: isDark
                      ? const Color(0xFFA7F3D0) // emerald-200
                      : AppColors.emerald800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Arabic text
          Text(
            'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTheme.arabicTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: isDark
                  ? const Color(0xFFD1FAE5) // emerald-100
                  : AppColors.emerald900,
            ).copyWith(height: 1.6),
          ),
          const SizedBox(height: 12),
          // Translation
          Text(
            '"হে আল্লাহ! আপনি পরম ক্ষমাশীল, আপনি ক্ষমা করতে ভালোবাসেন, তাই আমাকে ক্ষমা করুন।"',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? const Color(0xFF6EE7B7) // emerald-300
                  : const Color(0xFF047857), // emerald-700
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
