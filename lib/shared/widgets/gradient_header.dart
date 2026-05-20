import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/l10n/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_formatter.dart';
import '../../features/salah/providers/prayer_times_provider.dart';
import '../../features/salah/models/prayer_times_model.dart';

/// Gradient header widget with Ramadan day info and dynamic countdown.
class GradientHeader extends StatefulWidget {
  final int ramadanDay;
  final String profileImageUrl;

  const GradientHeader({
    super.key,
    required this.ramadanDay,
    this.profileImageUrl = '',
  });

  @override
  State<GradientHeader> createState() => _GradientHeaderState();
}

class _GradientHeaderState extends State<GradientHeader> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';
    final formattedDate =
        DateFormat('EEEE, d MMMM yyyy', langCode).format(_now);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF10D460), AppColors.emerald600],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Decorative mosque icon
          const Positioned(
            top: 0,
            right: 0,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.mosque_outlined,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
          // Decorative moon icon
          Positioned(
            bottom: -24,
            left: -24,
            child: Transform.rotate(
              angle: -0.2,
              child: const Opacity(
                opacity: 0.1,
                child: Icon(
                  Icons.bedtime_outlined,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Content
          Consumer<PrayerTimesProvider>(
            builder: (context, provider, child) {
              final data = provider.prayerTimes;

              String topTitle = data?.hijriDate ??
                  AppLocale.format(AppLocale.headerFetching);
              
              bool isRamadan = data?.isRamadan ?? true;

              // Override title for non-Ramadan
              if (data != null && !isRamadan) {
                topTitle = AppLocale.format(AppLocale.headerEverydayTitle);
              }

              String label1 = "";
              String value1 = "-- : --";
              String label2 = "";
              String value2 = "-- : --";

              if (data != null) {
                if (isRamadan) {
                  final fajrToday = TimeFormatter.parseToDateTime(data.fajr);
                  final maghribToday = TimeFormatter.parseToDateTime(data.maghrib);

                  if (fajrToday != null && maghribToday != null) {
                    if (_now.isBefore(fajrToday)) {
                      // Before Suhoor ends
                      label1 = AppLocale.format(AppLocale.headerSuhoorEnds);
                      value1 = _formatDuration(fajrToday.difference(_now));
                      label2 = AppLocale.format(AppLocale.headerIftarToday);
                      value2 = TimeFormatter.to12Hour(data.maghrib);
                    } else if (_now.isBefore(maghribToday)) {
                      // Fasting
                      label1 = AppLocale.format(AppLocale.headerIftarIn);
                      value1 = _formatDuration(maghribToday.difference(_now));
                      label2 = AppLocale.format(AppLocale.headerSuhoorTime);
                      value2 = TimeFormatter.to12Hour(data.fajr);
                    } else {
                      // After Iftar, next Suhoor
                      final fajrTomorrow = TimeFormatter.parseToDateTime(data.fajr, isNextDay: true);
                      label1 = AppLocale.format(AppLocale.headerSuhoorIn);
                      value1 = fajrTomorrow != null 
                          ? _formatDuration(fajrTomorrow.difference(_now))
                          : "-- : --";
                      label2 = AppLocale.format(AppLocale.headerIftarTime);
                      value2 = TimeFormatter.to12Hour(data.maghrib);
                    }
                  }
                } else {
                  // Everyday Mode (Non-Ramadan)
                  label1 = AppLocale.format(AppLocale.timeNextPrayer);
                  final nextPrayer = _findNextPrayer(data);
                  value1 = nextPrayer?.name ?? "--";
                  
                  label2 = AppLocale.format(AppLocale.timeNextPrayerIn);
                  value2 = nextPrayer != null 
                      ? _formatDurationShort(nextPrayer.time.difference(_now))
                      : "-- : --";
                }
              } else if (provider.isLoading) {
                value1 = AppLocale.format(AppLocale.headerLoading);
                value2 = AppLocale.format(AppLocale.headerLoading);
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Countdown stats
                    Row(
                      children: [
                        Expanded(
                          child: _CountdownCard(
                            label: label1,
                            value: value1,
                            isCountdown: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _CountdownCard(
                            label: label2,
                            value: value2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    final langCode =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';
    
    if (langCode == 'bn') {
      final h = TimeFormatter.toBengaliDigits(hours.toString().padLeft(2, '0'));
      final m = TimeFormatter.toBengaliDigits(minutes.toString().padLeft(2, '0'));
      final s = TimeFormatter.toBengaliDigits(seconds.toString().padLeft(2, '0'));
      return '$hঘ $mমি $sসে';
    }
    
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
  }

  String _formatDurationShort(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    final langCode =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';
    
    if (langCode == 'bn') {
      final h = TimeFormatter.toBengaliDigits(hours.toString());
      final m = TimeFormatter.toBengaliDigits(minutes.toString());
      return '$hঘ $mমি';
    }
    
    return '${hours}h ${minutes}m';
  }

  _NextPrayer? _findNextPrayer(PrayerTimesModel data) {
    final prayers = [
      ('Fajr', data.fajr),
      ('Dhuhr', data.dhuhr),
      ('Asr', data.asr),
      ('Maghrib', data.maghrib),
      ('Isha', data.isha),
    ];

    for (final p in prayers) {
      final time = TimeFormatter.parseToDateTime(p.$2);
      if (time != null && _now.isBefore(time)) {
        return _NextPrayer(AppLocale.format('time${p.$1}'), time);
      }
    }

    // If all prayers passed today, next is tomorrow's Fajr
    final fajrTomorrow = TimeFormatter.parseToDateTime(data.fajr, isNextDay: true);
    if (fajrTomorrow != null) {
      return _NextPrayer(AppLocale.format(AppLocale.timeFajr), fajrTomorrow);
    }
    return null;
  }
}

class _NextPrayer {
  final String name;
  final DateTime time;
  _NextPrayer(this.name, this.time);
}

class _CountdownCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isCountdown;

  const _CountdownCard({
    required this.label, 
    required this.value,
    this.isCountdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCountdown 
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCountdown 
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
          width: isCountdown ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isCountdown ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isCountdown ? FontWeight.bold : FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: isCountdown ? 18 : 16,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
