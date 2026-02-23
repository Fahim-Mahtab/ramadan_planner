import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/custom_card.dart';
import '../providers/salah_provider.dart';

/// Salah tracker widget displaying prayer grid
class SalahTrackerWidget extends StatelessWidget {
  const SalahTrackerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalahProvider>(
      builder: (context, salahProvider, child) {
        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstants.dailySalah,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryWith10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      salahProvider.completionStatus,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Prayer grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: salahProvider.prayers.length,
                itemBuilder: (context, index) {
                  final prayer = salahProvider.prayers[index];
                  return _PrayerButton(
                    name: prayer.name,
                    isCompleted: prayer.isCompleted,
                    onTap: () => salahProvider.togglePrayer(index),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PrayerButton extends StatelessWidget {
  final String name;
  final bool isCompleted;
  final VoidCallback onTap;

  const _PrayerButton({
    required this.name,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted
              ? AppColors.primary
              : (isDark ? AppColors.slate800 : AppColors.slate50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
                ? AppColors.primary
                : (isDark
                      ? AppColors.emerald800.withValues(alpha: 0.3)
                      : const Color(0xFFD1FAE5)), // emerald-200
            width: 2,
            style: isCompleted ? BorderStyle.solid : BorderStyle.solid,
          ),
          boxShadow: isCompleted
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isCompleted
                    ? Colors.white.withValues(alpha: 0.8)
                    : (isDark
                          ? AppColors.emerald800.withValues(alpha: 0.6)
                          : AppColors.emerald600),
              ),
            ),
            const SizedBox(height: 4),
            Icon(
              isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isCompleted
                  ? Colors.white
                  : (isDark
                        ? AppColors.emerald800.withValues(alpha: 0.6)
                        : AppColors.emerald600),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
