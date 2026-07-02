import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../models/quran_lecture_model.dart';

class LectureCard extends StatelessWidget {
  final QuranLectureModel lecture;
  final bool isCompleted;
  final bool isInProgress;
  final VoidCallback onTap;

  const LectureCard({
    super.key,
    required this.lecture,
    required this.isCompleted,
    required this.isInProgress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? AppColors.slate900 : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.slate800 : AppColors.emerald50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lecture.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.slate800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (lecture.description != null && lecture.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        lecture.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.slate400 : AppColors.slate500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (isCompleted)
                          _StatusChip(
                            label: AppLocale.format(AppLocale.lmsCompleted),
                            color: AppColors.primary,
                            isDark: isDark,
                          )
                        else if (isInProgress)
                          _StatusChip(
                            label: AppLocale.format(AppLocale.lmsInProgress),
                            color: AppColors.gold,
                            isDark: isDark,
                          ),
                        const Spacer(),
                        Text(
                          AppLocale.format(AppLocale.lmsWatch),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
