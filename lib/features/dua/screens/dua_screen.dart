import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../salah/providers/prayer_times_provider.dart';
import '../providers/hadith_provider.dart';
import '../widgets/dua_card.dart';
import '../widgets/last_ten_days_hadith_card.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  @override
  Widget build(BuildContext context) {
    // Reactively watch PrayerTimesProvider so we fetch the hadith as soon as the date is available
    final prayerTimesProvider = context.watch<PrayerTimesProvider>();
    final hijriDateStr = prayerTimesProvider.prayerTimes?.hijriDate;

    if (hijriDateStr != null && hijriDateStr.toLowerCase().contains('ramadan')) {
      final parts = hijriDateStr.split(' ');
      if (parts.isNotEmpty) {
        final dayStr = parts[0];
        final day = int.tryParse(dayStr);
        if (day != null && day >= 21 && day <= 30) {
          // Schedule a fetch to avoid modifying provider during build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.read<HadithProvider>().fetchHadithForDay(day);
            }
          });
        }
      }
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? screenWidth * 0.08 : 20.0;

    return SingleChildScrollView(
      child: Column(
        children: [
          const GradientHeader(ramadanDay: 1, profileImageUrl: ''), // Using existing header pattern
          Transform.translate(
            offset: const Offset(0, -16),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LastTenDaysHadithCard(),
                  const DuaCard(),
                  const SizedBox(height: 110), // Nav bar spacing
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
