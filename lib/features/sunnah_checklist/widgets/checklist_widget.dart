import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/custom_card.dart';
import '../providers/checklist_provider.dart';

/// Sunnah checklist widget
class ChecklistWidget extends StatelessWidget {
  const ChecklistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChecklistProvider>(
      builder: (context, checklistProvider, child) {
        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.sunnahChecklist,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...List.generate(checklistProvider.items.length, (index) {
                final item = checklistProvider.items[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < checklistProvider.items.length - 1 ? 16 : 0,
                  ),
                  child: _ChecklistItem(
                    title: item.title,
                    isCompleted: item.isCompleted,
                    onTap: () => checklistProvider.toggleItem(index),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final VoidCallback onTap;

  const _ChecklistItem({
    required this.title,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.primary
                      : (isDark
                            ? AppColors.emerald800
                            : const Color(0xFFD1FAE5)), // emerald-200
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          // Title
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isCompleted
                    ? (isDark ? AppColors.slate500 : AppColors.slate500)
                    : (isDark ? AppColors.slate300 : AppColors.slate700),
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
