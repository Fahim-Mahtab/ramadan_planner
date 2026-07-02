import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../models/hadith_model.dart';
import '../providers/hadith_provider.dart';

class HadithDetailTile extends StatelessWidget {
  final HadithModel hadith;

  const HadithDetailTile({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final provider = context.watch<HadithProvider>();
    final saved = provider.isBookmarked(hadith.number);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '#' '${hadith.number}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    saved ? Icons.bookmark : Icons.bookmark_border,
                    color: saved ? AppColors.primary : null,
                    size: 20,
                  ),
                  onPressed: () => provider.toggleBookmark(hadith.number),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    '— ${hadith.sourceEn}',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: isDark ? AppColors.slate500 : AppColors.slate400,
                    ),
                  ),
                ),
                Text(
                  hadith.narrator,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.slate500 : AppColors.slate400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              hadith.reference,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.slate600 : AppColors.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
