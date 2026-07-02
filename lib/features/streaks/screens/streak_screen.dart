import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/streak_provider.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StreakProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.streakTitle),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.slate800,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: isDark ? AppColors.slate400 : AppColors.slate500),
            onPressed: () => context.read<StreakProvider>().refresh(),
          ),
        ],
      ),
      body: Consumer<StreakProvider>(
        builder: (context, provider, _) {
          if (!provider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BestStreakCard(streak: provider.bestStreak, isDark: isDark),
                const SizedBox(height: 24),
                Text(
                  AppLocale.format(AppLocale.streakYourStreaks),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.slate800,
                  ),
                ),
                const SizedBox(height: 12),
                _StreakCard(
                  icon: Icons.mosque_rounded,
                  label: AppLocale.format(AppLocale.streakSalah),
                  streak: provider.salahStreak,
                  color: AppColors.primary,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                _StreakCard(
                  icon: Icons.checklist_rounded,
                  label: AppLocale.format(AppLocale.streakSunnahChecklist),
                  streak: provider.checklistStreak,
                  color: AppColors.gold,
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                _StreakCard(
                  icon: Icons.menu_book_rounded,
                  label: AppLocale.format(AppLocale.streakQuranReading),
                  streak: provider.quranStreak,
                  color: AppColors.emerald600,
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.slate900 : AppColors.slate50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.slate700 : AppColors.slate200,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.gold, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocale.format(AppLocale.streakInfo),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.slate400 : AppColors.slate500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BestStreakCard extends StatelessWidget {
  final int streak;
  final bool isDark;

  const _BestStreakCard({required this.streak, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withAlpha(30),
            AppColors.gold.withAlpha(20),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(40)),
      ),
      child: Column(
        children: [
          Icon(Icons.local_fire_department_rounded, color: AppColors.gold, size: 48),
          const SizedBox(height: 12),
          Text(
            '$streak',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.slate800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocale.format(AppLocale.streakDayStreak),
            style: TextStyle(
              fontSize: 16,
              color: isDark ? AppColors.slate300 : AppColors.slate600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              streak >= 30
                  ? 'Outstanding! \u{1F929}'
                  : streak >= 14
                      ? 'Amazing progress!'
                      : streak >= 7
                          ? 'Keep it up!'
                          : streak >= 3
                              ? 'Good start!'
                              : AppLocale.format(AppLocale.streakStayConsistent),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int streak;
  final Color color;
  final bool isDark;

  const _StreakCard({
    required this.icon,
    required this.label,
    required this.streak,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.slate800,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (streak / 30).clamp(0.0, 1.0),
                    backgroundColor: isDark ? AppColors.slate800 : AppColors.slate100,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$streak days',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: streak >= 7 ? color : (isDark ? AppColors.slate300 : AppColors.slate600),
            ),
          ),
        ],
      ),
    );
  }
}
