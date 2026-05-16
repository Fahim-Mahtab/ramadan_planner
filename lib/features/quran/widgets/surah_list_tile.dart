import 'package:flutter/material.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../models/surah_info_model.dart';
import '../screens/surah_detail_screen.dart';

class SurahListTile extends StatelessWidget {
  final SurahInfoModel surah;

  const SurahListTile({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${surah.surahNo}',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
      title: Text(
        surah.surahName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        '${surah.revelationPlace} • ${surah.totalAyah} ${AppLocale.format(AppLocale.quranVerses)}',
        style: TextStyle(
          color: isDark ? AppColors.slate400 : AppColors.slate600,
          fontSize: 12,
        ),
      ),
      trailing: Text(
        surah.surahNameArabic,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurahDetailScreen(surah: surah),
          ),
        );
      },
    );
  }
}
