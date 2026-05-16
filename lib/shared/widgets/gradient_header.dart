import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/l10n/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_formatter.dart';
import '../../features/salah/providers/prayer_times_provider.dart';

/// Gradient header widget with Ramadan day info and countdown.
class GradientHeader extends StatelessWidget {
  final int ramadanDay;
  final String profileImageUrl;

  const GradientHeader({
    super.key,
    required this.ramadanDay,
    this.profileImageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final langCode =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';
    final formattedDate =
        DateFormat('EEEE, d MMMM yyyy', langCode).format(now);

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
              String iftarTime = "-- : --";
              String suhoorTime = "-- : --";

              if (data != null) {
                iftarTime = TimeFormatter.to12Hour(data.maghrib);
                suhoorTime = TimeFormatter.to12Hour(data.fajr);
              } else if (provider.isLoading) {
                iftarTime = AppLocale.format(AppLocale.headerLoading);
                suhoorTime = AppLocale.format(AppLocale.headerLoading);
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
                            label: AppLocale.format(AppLocale.headerIftar),
                            value: iftarTime,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _CountdownCard(
                            label: AppLocale.format(AppLocale.headerSuhoor),
                            value: suhoorTime,
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
}

class _CountdownCard extends StatelessWidget {
  final String label;
  final String value;

  const _CountdownCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
