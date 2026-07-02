import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../data/sunnah_acts.dart';

class SunnahItemTile extends StatelessWidget {
  final SunnahAct act;
  final bool isCompleted;
  final VoidCallback onTap;

  const SunnahItemTile({
    super.key,
    required this.act,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
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
                        : (isDark ? AppColors.emerald800 : const Color(0xFFD1FAE5)),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    act.titleEn,
                    style: TextStyle(
                      fontSize: 14,
                      color: isCompleted
                          ? (isDark ? AppColors.slate500 : AppColors.slate500)
                          : (isDark ? AppColors.slate300 : AppColors.slate700),
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    act.evidence,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AppColors.slate500 : AppColors.slate400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
