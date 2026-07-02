import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../models/fasting_record.dart';
import '../providers/fasting_provider.dart';
import '../widgets/fasting_calendar.dart';
import '../widgets/fasting_stats.dart';
import '../widgets/fasting_legend.dart';

class FastingScreen extends StatefulWidget {
  const FastingScreen({super.key});

  @override
  State<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends State<FastingScreen> {
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FastingProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.fastingTitle),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.slate800,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<FastingProvider>(
        builder: (context, provider, _) {
          if (!provider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          final selectedDay = _selectedDay ?? DateTime.now();
          final existingStatus = provider.getStatus(selectedDay);

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocale.format(AppLocale.fastingDescription),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.slate400 : AppColors.slate500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FastingStats(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocale.format(AppLocale.fastingCalendar),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.slate800,
                            ),
                          ),
                          Text(
                            '${AppLocale.format(AppLocale.fastingStreak)}: ${provider.longestStreak}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.slate400 : AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                FastingCalendarWidget(
                  focusedDay: _focusedDay,
                  onDaySelected: (day) => setState(() => _selectedDay = day),
                ),
                const FastingLegend(),
                const SizedBox(height: 16),
                ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _SelectedDayCard(
                      date: selectedDay,
                      status: existingStatus,
                      isDark: isDark,
                      onTap: () => _toggleFast(selectedDay, provider),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _toggleFast(DateTime day, FastingProvider provider) {
    final isMonThu = day.isMonday || day.isThursday;
    final isWhite = day.day >= 13 && day.day <= 15;
    final type = isMonThu
        ? FastType.mondayThursday
        : isWhite
            ? FastType.whiteDays
            : FastType.voluntary;
    provider.toggleDay(day, type);
  }
}

class _SelectedDayCard extends StatelessWidget {
  final DateTime date;
  final FastStatus? status;
  final bool isDark;
  final VoidCallback onTap;

  const _SelectedDayCard({
    required this.date,
    required this.status,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMonThu = date.isMonday || date.isThursday;
    final isWhite = date.day >= 13 && date.day <= 15;
    final isRecommended = isMonThu || isWhite;
    final isToday = date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecommended
              ? AppColors.gold.withAlpha(80)
              : (isDark ? AppColors.slate700 : AppColors.slate200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.slate800,
                  ),
                ),
                const SizedBox(height: 4),
                if (isToday)
                  Text(
                      AppLocale.format(AppLocale.fastingToday),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (isMonThu)
                  Text(
                    date.weekday == DateTime.monday ? AppLocale.format(AppLocale.fastingMonday) : AppLocale.format(AppLocale.fastingThursday),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.gold,
                    ),
                  ),
                if (isWhite)
                  Text(
                    AppLocale.format(AppLocale.fastingWhiteDays),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.gold,
                    ),
                  ),
                if (status == FastStatus.kept)
                  Text(
                    AppLocale.format(AppLocale.fastingFastKept),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                if (status == FastStatus.missed)
                  Text(
                    AppLocale.format(AppLocale.fastingMissed),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.warning,
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              backgroundColor: status == FastStatus.kept
                  ? AppColors.primary.withAlpha(25)
                  : (isDark ? AppColors.slate800 : AppColors.slate100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              status == FastStatus.kept ? AppLocale.format(AppLocale.fastingMarkMissed) : AppLocale.format(AppLocale.fastingMarkKept),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: status == FastStatus.kept
                    ? AppColors.warning
                    : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
