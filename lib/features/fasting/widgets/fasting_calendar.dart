import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../models/fasting_record.dart';
import '../providers/fasting_provider.dart';

class FastingCalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final ValueChanged<DateTime> onDaySelected;

  const FastingCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final provider = context.watch<FastingProvider>();

    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: focusedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.slate800,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: isDark ? AppColors.slate300 : AppColors.slate600,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: isDark ? AppColors.slate300 : AppColors.slate600,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: isDark ? AppColors.slate400 : AppColors.slate500,
          fontSize: 12,
        ),
        weekendStyle: TextStyle(
          color: isDark ? AppColors.slate400 : AppColors.slate500,
          fontSize: 12,
        ),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        todayDecoration: BoxDecoration(
          color: AppColors.primary.withAlpha(50),
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        selectedDecoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        defaultDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        weekendDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        markerDecoration: const BoxDecoration(
          color: AppColors.gold,
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          final status = provider.getStatus(date);
          if (status == FastStatus.kept) {
            return Positioned(
              bottom: 2,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }
          if (status == FastStatus.missed) {
            return Positioned(
              bottom: 2,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.warning,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }
          return null;
        },
      ),
      onDaySelected: (selected, focused) => onDaySelected(selected),
      selectedDayPredicate: (day) {
        final status = provider.getStatus(day);
        return status != null;
      },
    );
  }
}
