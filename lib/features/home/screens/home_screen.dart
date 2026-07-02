import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../salah/widgets/salah_tracker_widget.dart';
import '../../quran/widgets/quran_progress_widget.dart';
import '../../sunnah_checklist/widgets/ai_sunnah_carousel.dart';
import '../../ayah/widgets/ayah_card.dart';
import '../../dua/widgets/dua_card.dart';
import '../../asmaul_husna/widgets/asmaul_husna_card.dart';
import '../../hadith/widgets/hadith_card.dart';
import '../../more/screens/more_screen.dart';
import '../../quran/screens/quran_screen.dart';
import '../../salah/screens/time_screen.dart';
import '../../dua/screens/dua_screen.dart';
import '../../salah/providers/prayer_times_provider.dart';
import '../../notices/widgets/notice_board_widget.dart';
import '../widgets/community_hero_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

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

  void _onNavTap(int index) => setState(() => _currentNavIndex = index);

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const _HomePage();
      case 1:
        return const QuranScreen();
      case 2:
        return const TimeScreen();
      case 3:
        return const DuaScreen();
      case 4:
        return const MoreScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildPage(_currentNavIndex),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(
              currentIndex: _currentNavIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? screenWidth * 0.08 : 20.0;

    return SingleChildScrollView(
      child: Column(
        children: [
          const GradientHeader(ramadanDay: 1, profileImageUrl: ''),
          Transform.translate(
            offset: const Offset(0, -16),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Consumer<PrayerTimesProvider>(
                builder: (context, provider, _) {
                  final isRamadan = provider.prayerTimes?.isRamadan ?? true;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NoticeBoardWidget(),
                      const SizedBox(height: 16),
                      const CommunityHeroCard(),
                      const SizedBox(height: 16),
                      _SectionHeader(
                          label: AppLocale.format(AppLocale.homeInspirations)),
                      const SizedBox(height: 12),
                      const AyahCard(),
                      const SizedBox(height: 16),
                      const HadithCard(),
                      const SizedBox(height: 16),
                      const DuaCard(),
                      const SizedBox(height: 16),
                      const AsmaulHusnaCard(),
                      const SizedBox(height: 24),
                      _SectionHeader(
                          label: AppLocale.format(AppLocale.homeDailyAmal)),
                      const SizedBox(height: 12),
                      const SalahTrackerWidget(),
                      const SizedBox(height: 24),
                      const AISunnahCarousel(),
                      const SizedBox(height: 24),
                      if (isRamadan) ...[
                        const QuranProgressWidget(),
                        const SizedBox(height: 24),
                      ],
                      const SizedBox(height: 110),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: isDark ? AppColors.slate300 : AppColors.slate600,
          ),
        ),
      ],
    );
  }
}
