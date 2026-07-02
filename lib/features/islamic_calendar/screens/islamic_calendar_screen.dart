import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/salah/providers/prayer_times_provider.dart';
import '../data/islamic_events.dart';
import '../providers/islamic_calendar_provider.dart';
import '../widgets/event_card.dart';

class IslamicCalendarScreen extends StatefulWidget {
  const IslamicCalendarScreen({super.key});

  @override
  State<IslamicCalendarScreen> createState() => _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState extends State<IslamicCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _format = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pt = context.read<PrayerTimesProvider>();
      final ic = context.read<IslamicCalendarProvider>();
      if (pt.prayerTimes != null && pt.prayerTimes!.hijriDate.isNotEmpty) {
        final parts = pt.prayerTimes!.hijriDate.split(' ');
        if (parts.length >= 3) {
          final day = int.tryParse(parts[0]) ?? 1;
          final monthName = parts.length > 1 ? parts[1] : '';
          final year = parts.length > 2 ? int.tryParse(parts[2]) ?? 1447 : 1447;
          final month = hijriMonths.entries.firstWhere(
            (e) => e.value.contains(monthName),
            orElse: () => const MapEntry(1, ''),
          ).key;
          ic.updateHijriDate(day, month, year);
        }
      } else {
        ic.updateHijriDate(1, 9, 1447);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final provider = context.watch<IslamicCalendarProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.islamicCalendarTitle),
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
      body: Column(
        children: [
          if (provider.isInitialized)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.gold.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gold.withAlpha(40)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, color: AppColors.gold, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    provider.hijriDateStr,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.slate800,
                    ),
                  ),
                ],
              ),
            ),
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _format,
            onFormatChanged: (format) => setState(() => _format = format),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.slate800,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: isDark ? AppColors.slate300 : AppColors.slate600),
              rightChevronIcon: Icon(Icons.chevron_right, color: isDark ? AppColors.slate300 : AppColors.slate600),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: isDark ? AppColors.slate400 : AppColors.slate500, fontSize: 12),
              weekendStyle: TextStyle(color: isDark ? AppColors.slate400 : AppColors.slate500, fontSize: 12),
            ),
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withAlpha(50),
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              selectedDecoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              markerDecoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
            ),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          ),
          const Divider(height: 1),
          Expanded(
            child: _buildEventsList(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(IslamicCalendarProvider provider) {
    final events = provider.eventsForCurrentMonth;
    if (events.isEmpty) {
      return Center(
        child: Text(
          AppLocale.format(AppLocale.islamicCalendarNoEvents),
          style: TextStyle(
            color: context.isDark ? AppColors.slate400 : AppColors.slate500,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: events.length,
      itemBuilder: (_, i) => EventCard(event: events[i]),
    );
  }
}
