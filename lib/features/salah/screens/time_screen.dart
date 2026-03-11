import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/time_formatter.dart';
import '../providers/prayer_times_provider.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PrayerTimesProvider>();
      if (provider.prayerTimes == null && !provider.isLoading) {
        provider.fetchPrayerTimes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times'), centerTitle: true),
      body: Consumer<PrayerTimesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Fetching location and timings..."),
                ],
              ),
            );
          }

          if (provider.error != null && provider.prayerTimes == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off,
                      size: 64,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => provider.fetchPrayerTimes(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry Location'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = provider.prayerTimes;
          if (data == null) {
            return const Center(child: Text("No timing data available."));
          }

          return RefreshIndicator(
            onRefresh: provider.fetchPrayerTimes,
            child: ListView(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 110),
              children: [
                // Header (Location & Date)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.locality,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data.hijriDate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.gregorianDate,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Iftar Highlight
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.wb_sunny_rounded, color: AppColors.gold),
                          SizedBox(width: 12),
                          Text(
                            "Iftar Time\n(Maghrib)",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        TimeFormatter.to12Hour(data.maghrib),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Prayer Times Table",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                // Timetable
                _buildTimeTile(
                  "Fajr",
                  TimeFormatter.to12Hour(data.fajr),
                  Icons.nights_stay,
                  isDark,
                ),
                _buildTimeTile(
                  "Sunrise",
                  TimeFormatter.to12Hour(data.sunrise),
                  Icons.wb_twilight,
                  isDark,
                ),
                _buildTimeTile(
                  "Dhuhr",
                  TimeFormatter.to12Hour(data.dhuhr),
                  Icons.wb_sunny,
                  isDark,
                ),
                _buildTimeTile(
                  "Asr",
                  TimeFormatter.to12Hour(data.asr),
                  Icons.wb_cloudy,
                  isDark,
                ),
                _buildTimeTile(
                  "Maghrib",
                  TimeFormatter.to12Hour(data.maghrib),
                  Icons.brightness_3,
                  isDark,
                  isHighlight: true,
                ),
                _buildTimeTile(
                  "Isha",
                  TimeFormatter.to12Hour(data.isha),
                  Icons.star,
                  isDark,
                ),
              ],
            ),
          );
        },
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.gold.withValues(alpha: 0.1)
            : (isDark ? AppColors.slate800 : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlight
              ? AppColors.gold
              : (isDark ? AppColors.slate700 : AppColors.slate300),
          width: 1,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isHighlight ? AppColors.gold : AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
                  color: isHighlight ? AppColors.gold : null,
                ),
              ),
            ],
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isHighlight ? AppColors.gold : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
