import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/custom_card.dart';
import '../providers/salah_provider.dart';
import '../providers/prayer_times_provider.dart';
import '../models/salah_model.dart';

/// Salah tracker widget displaying prayer grid
class SalahTrackerWidget extends StatelessWidget {
  const SalahTrackerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SalahProvider, PrayerTimesProvider>(
      builder: (context, salahProvider, prayerTimesProvider, child) {
        if (salahProvider.isLoading) {
          return const CustomCard(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final prayerTimes = prayerTimesProvider.prayerTimes;
        List<Map<String, dynamic>> visiblePrayers = [];

        if (prayerTimes != null) {
          final now = DateTime.now();
          final format = DateFormat("HH:mm");

          DateTime parseTime(String time) {
            try {
              final rawTime = time.split(' ').first;
              final parsed = format.parse(rawTime);
              return DateTime(
                now.year,
                now.month,
                now.day,
                parsed.hour,
                parsed.minute,
              );
            } catch (e) {
              return DateTime(now.year, now.month, now.day, 0, 0);
            }
          }

          final prayerTimeMap = {
            'Fajr': parseTime(prayerTimes.fajr),
            'Dhuhr': parseTime(prayerTimes.dhuhr),
            'Asr': parseTime(prayerTimes.asr),
            'Maghrib': parseTime(prayerTimes.maghrib),
            'Isha': parseTime(prayerTimes.isha),
          };

          for (int i = 0; i < salahProvider.prayers.length; i++) {
            final prayer = salahProvider.prayers[i];
            final time = prayerTimeMap[prayer.name];
            bool hasStarted = true;
            if (time != null) {
              hasStarted = now.isAfter(time);
            }
            if (hasStarted) {
              visiblePrayers.add({'index': i, 'prayer': prayer});
            }
          }
        } else {
          for (int i = 0; i < salahProvider.prayers.length; i++) {
            visiblePrayers.add({
              'index': i,
              'prayer': salahProvider.prayers[i],
            });
          }
        }

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
              if (visiblePrayers.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      "Waiting for Fajr time to begin...",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
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
                  itemCount: visiblePrayers.length,
                  itemBuilder: (context, index) {
                    final item = visiblePrayers[index];
                    final originalIndex = item['index'] as int;
                    final prayer = item['prayer'] as SalahModel;

                    return _PrayerButton(
                      name: prayer.name,
                      isCompleted: prayer.isCompleted,
                      onTap: () => salahProvider.togglePrayer(originalIndex),
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
