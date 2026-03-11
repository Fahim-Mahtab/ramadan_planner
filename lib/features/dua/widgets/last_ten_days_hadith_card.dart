import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hadith_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class LastTenDaysHadithCard extends StatelessWidget {
  const LastTenDaysHadithCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HadithProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.lastFetchedDay == null) {
          // If not in the last 10 days, or haven't checked yet, show nothing.
          return const SizedBox.shrink();
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final hadith = provider.todayHadith;

        if (hadith == null) {
          // Return the empty state design if it's the last 10 days but no hadith exists.
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.auto_stories_rounded, color: AppColors.primary.withValues(alpha: 0.5), size: 40),
                const SizedBox(height: 16),
                Text(
                  'RAMADAN DAY ${provider.lastFetchedDay}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: isDark ? Colors.white70 : AppColors.slate600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'No hadith posted yet',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.white54 : AppColors.slate500,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_rounded, color: AppColors.gold, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'RAMADAN DAY ${hadith.ramadanDay} HADITH',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: isDark ? Colors.white70 : AppColors.slate600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.star_rounded, color: AppColors.gold, size: 20),
                ],
              ),
              const SizedBox(height: 20),
              
              // Arabic Text
              Text(
                hadith.arabicText,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTheme.arabicTextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: isDark ? Colors.white : AppColors.slate900,
                ).copyWith(height: 1.8),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16),
              
              // Bangla Translation
              Text(
                hadith.banglaTranslation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : AppColors.slate700,
                  height: 1.6,
                ),
              ),
              
              // English Translation
              if (hadith.englishTranslation != null && hadith.englishTranslation!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  hadith.englishTranslation!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white54 : AppColors.slate500,
                    height: 1.5,
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Source
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  hadith.source,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
