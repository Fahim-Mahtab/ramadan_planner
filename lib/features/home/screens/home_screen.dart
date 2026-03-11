import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../salah/providers/prayer_times_provider.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../salah/widgets/salah_tracker_widget.dart';
import '../../quran/widgets/quran_progress_widget.dart';
import '../../ayah/widgets/ayah_card.dart';
import '../../sunnah_checklist/widgets/checklist_widget.dart';
import '../../dua/widgets/dua_card.dart';
import '../../asmaul_husna/widgets/asmaul_husna_card.dart';
import '../../ads/widgets/home_ad_banner.dart';
import '../../notes/widgets/daily_note_widget.dart';
import '../../settings/screens/settings_screen.dart';
import '../../dua/screens/dua_screen.dart';
import '../../quran/screens/quran_screen.dart';
import '../../salah/screens/time_screen.dart';

/// Main home screen — shows all Ramadan tracking features,
/// with a bottom nav bar to switch between tabs.
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
    // Fetch data immediately when app opens to populate other widgets
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<PrayerTimesProvider>();
      if (provider.prayerTimes == null && !provider.isLoading) {
        provider.fetchPrayerTimes();
      }
    });
  }

  void _onNavTap(int index) => setState(() => _currentNavIndex = index);

  // The five tab pages. Pages without a dedicated widget show a placeholder.
  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _HomePage();
      case 1:
        return const QuranScreen();
      case 2:
        return const TimeScreen();
      case 3:
        return const DuaScreen();
      case 4:
        return const SettingsScreen();
      default:
        return _ComingSoonPage(
          label: ['Home', 'Quran', 'Times', 'Dua', 'Settings'][index],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Active tab content ─────────────────────────────────────────
          _buildPage(_currentNavIndex),

          // ── Bottom Navigation Bar ──────────────────────────────────────
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

// ── Home tab content ───────────────────────────────────────────────────────────

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? screenWidth * 0.08 : 20.0;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Gradient Header (no logout — moved to Settings)
          const GradientHeader(ramadanDay: 1, profileImageUrl: ''),

          // Main content — slight overlap with header
          Transform.translate(
            offset: const Offset(0, -16),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: const Column(
                children: [
                  SalahTrackerWidget(),
                  SizedBox(height: 24),
                  HomeAdBanner(),
                  SizedBox(height: 24),
                  AyahCard(),
                  SizedBox(height: 24),
                  QuranProgressWidget(),
                  SizedBox(height: 24),
                  ChecklistWidget(),
                  SizedBox(height: 24),
                  DuaCard(),
                  SizedBox(height: 24),
                  AsmaulHusnaCard(),
                  SizedBox(height: 24),
                  DailyNoteWidget(),
                  // Bottom padding for nav bar
                  SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Coming-soon placeholder ────────────────────────────────────────────────────

class _ComingSoonPage extends StatelessWidget {
  final String label;
  const _ComingSoonPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.construction_rounded,
              size: 56,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              '$label screen coming soon!',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            // Extra space so it clears the nav bar
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
