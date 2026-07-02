import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../data/sunnah_acts.dart';
import '../providers/checklist_provider.dart';

class CategoryProgress extends StatelessWidget {
  final SunnahCategory category;

  const CategoryProgress({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChecklistProvider>(
      builder: (context, provider, _) {
        final acts = provider.items.where((item) {
          return allSunnahActs.any((a) => a.key == item.key && a.category.runtimeType == category.runtimeType);
        }).toList();
        final done = acts.where((a) => a.isCompleted).length;
        final total = acts.length;
        final progress = total > 0 ? done / total : 0.0;
        final isDark = context.isDark;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getLabel(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.slate300 : AppColors.slate600,
                    ),
                  ),
                  Text(
                    '$done/$total',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.slate500 : AppColors.slate400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: isDark ? AppColors.slate800 : AppColors.slate100,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress == 1.0 ? AppColors.primary : AppColors.gold,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getLabel() => category.key == 'morning_evening'
      ? (category.labelEn)
      : category.labelEn;
}
