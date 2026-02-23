import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/gradient_header.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../salah/widgets/salah_tracker_widget.dart';
import '../../quran/widgets/quran_progress_widget.dart';
import '../../ayah/widgets/ayah_card.dart';
import '../../sunnah_checklist/widgets/checklist_widget.dart';
import '../../dua/widgets/dua_card.dart';
import '../../asmaul_husna/widgets/asmaul_husna_card.dart';

/// Main home screen displaying all Ramadan tracking features.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
    if (index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${['Home', 'Quran', 'Times', 'Dua', 'Settings'][index]} screen coming soon!',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  /// Shows a confirmation dialog then signs the user out.
  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to use the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AuthProvider>().signOut();
      // AuthGate's stream listener automatically routes back to LoginScreen.
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? screenWidth * 0.08 : 20.0;

    return Scaffold(
      body: Stack(
        children: [
          // ── Scrollable content ──────────────────────────────────────────
          SingleChildScrollView(
            child: Column(
              children: [
                // Gradient Header with built-in logout button
                GradientHeader(
                  ramadanDay: 1,
                  profileImageUrl: '',
                  onLogout: _confirmLogout,
                ),

                // Main content — slight overlap with header
                Transform.translate(
                  offset: const Offset(0, -16),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      children: [
                        // Salah Tracker
                        const SalahTrackerWidget(),
                        const SizedBox(height: 24),

                        // Ayah of the Day
                        const AyahCard(),
                        const SizedBox(height: 24),

                        // Quran Progress
                        const QuranProgressWidget(),
                        const SizedBox(height: 24),

                        // Sunnah Checklist
                        const ChecklistWidget(),
                        const SizedBox(height: 24),

                        // Dua of the Day
                        const DuaCard(),
                        const SizedBox(height: 24),

                        // Asmaul Husna
                        const AsmaulHusnaCard(),

                        // Bottom padding for nav bar + extra breathing room
                        const SizedBox(height: 110),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Logout button — top-right corner ───────────────────────────
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 16),
                child: _LogoutButton(onTap: _confirmLogout),
              ),
            ),
          ),

          // ── Bottom Navigation Bar ───────────────────────────────────────
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

// ── Logout button widget ───────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Consumer<AuthProvider>(
        builder: (_, auth, _) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: auth.isLoading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout_rounded, size: 15, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
