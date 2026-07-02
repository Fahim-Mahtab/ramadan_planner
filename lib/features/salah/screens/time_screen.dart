import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/time_formatter.dart';
import '../providers/prayer_times_provider.dart';
import '../widgets/prayer_clock_widget.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PrayerTimesProvider>();
      if (provider.prayerTimes == null && !provider.isLoading) {
        provider.fetchPrayerTimes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.format(AppLocale.timePrayerTimes)),
        centerTitle: true,
      ),
      body: Consumer<PrayerTimesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(AppLocale.format(AppLocale.timeFetching),
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            );
          }

          if (provider.error != null && provider.prayerTimes == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off, size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text(provider.error!, textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => provider.fetchPrayerTimes(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(AppLocale.format(AppLocale.timeRetry)),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = provider.prayerTimes;
          if (data == null) {
            return Center(
              child: Text(AppLocale.format(AppLocale.timeNoData),
                  style: const TextStyle(fontSize: 14)),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.fetchPrayerTimes,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
              children: [
                _buildHeader(provider, data, isDark),
                const SizedBox(height: 20),
                const PrayerClockWidget(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: Text(
                    AppLocale.format(AppLocale.timeTableTitle),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.slate300 : AppColors.slate600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildTimeTile(AppLocale.format(AppLocale.timeFajr),
                    TimeFormatter.to12Hour(data.fajr), Icons.nights_stay, isDark),
                _buildTimeTile(AppLocale.format(AppLocale.timeSunrise),
                    TimeFormatter.to12Hour(data.sunrise), Icons.wb_twilight, isDark),
                _buildTimeTile(AppLocale.format(AppLocale.timeDhuhr),
                    TimeFormatter.to12Hour(data.dhuhr), Icons.wb_sunny, isDark),
                _buildTimeTile(AppLocale.format(AppLocale.timeAsr),
                    TimeFormatter.to12Hour(data.asr), Icons.wb_cloudy, isDark),
                _buildTimeTile(AppLocale.format(AppLocale.timeMaghrib),
                    TimeFormatter.to12Hour(data.maghrib), Icons.brightness_3, isDark),
                _buildTimeTile(AppLocale.format(AppLocale.timeIsha),
                    TimeFormatter.to12Hour(data.isha), Icons.star, isDark),
                _buildTimeTile(AppLocale.format(AppLocale.timeJummah),
                    TimeFormatter.to12Hour(data.jummah), Icons.groups_outlined, isDark),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
      PrayerTimesProvider provider, dynamic data, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider.locality,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center),
                const SizedBox(height: 2),
                Text(data.hijriDate,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Text(data.gregorianDate,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildTimeTile(
    String name,
    String time,
    IconData icon,
    bool isDark, {
    bool isHighlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.gold.withValues(alpha: 0.08)
            : (isDark ? AppColors.slate800 : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight
              ? AppColors.gold.withValues(alpha: 0.4)
              : (isDark ? AppColors.slate700 : AppColors.slate200),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: (isHighlight ? AppColors.gold : AppColors.primary)
                  .withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon,
                color: isHighlight ? AppColors.gold : AppColors.primary,
                size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
                    color: isHighlight
                        ? AppColors.gold
                        : (isDark ? AppColors.slate200 : AppColors.slate700))),
          ),
          Text(time,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isHighlight
                      ? AppColors.gold
                      : (isDark ? AppColors.emerald600 : AppColors.primary))),
        ],
      ),
    );
  }
}
