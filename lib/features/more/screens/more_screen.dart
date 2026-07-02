import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n/app_locale.dart';
import '../widgets/tool_grid_item.dart';
import '../../tasbih/screens/tasbih_screen.dart';
import '../../qibla/screens/qibla_screen.dart';
import '../../fasting/screens/fasting_screen.dart';
import '../../hadith/screens/hadith_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../islamic_calendar/screens/islamic_calendar_screen.dart';
import '../../streaks/screens/streak_screen.dart';
import '../../charity/screens/charity_screen.dart';
import '../../quran_plan/screens/quran_plan_screen.dart';
import '../../journal/screens/journal_screen.dart';
import '../../mosque/screens/mosque_screen.dart';
import '../../zakat/screens/ai_zakat_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    final tools = [
      _ToolData(
        icon: Icons.volunteer_activism_rounded,
        label: AppLocale.format(AppLocale.moreTasbih),
        color: AppColors.primary,
        screen: const TasbihScreen(),
      ),
      _ToolData(
        icon: Icons.explore_rounded,
        label: AppLocale.format(AppLocale.moreQibla),
        color: AppColors.gold,
        screen: const QiblaScreen(),
      ),
      _ToolData(
        icon: Icons.calendar_month_rounded,
        label: AppLocale.format(AppLocale.moreFasting),
        color: AppColors.emerald600,
        screen: const FastingScreen(),
      ),
      _ToolData(
        icon: Icons.auto_stories_rounded,
        label: AppLocale.format(AppLocale.moreHadith),
        color: AppColors.warning,
        screen: const HadithScreen(),
      ),
      _ToolData(
        icon: Icons.calendar_today_rounded,
        label: AppLocale.format(AppLocale.moreIslamicCalendar),
        color: AppColors.emerald700,
        screen: const IslamicCalendarScreen(),
      ),
      _ToolData(
        icon: Icons.local_fire_department_rounded,
        label: AppLocale.format(AppLocale.moreStreaks),
        color: AppColors.gold,
        screen: const StreakScreen(),
      ),
      _ToolData(
        icon: Icons.card_giftcard_rounded,
        label: AppLocale.format(AppLocale.moreCharity),
        color: AppColors.primary,
        screen: const CharityScreen(),
      ),
      _ToolData(
        icon: Icons.menu_book_rounded,
        label: AppLocale.format(AppLocale.moreQuranPlan),
        color: AppColors.emerald800,
        screen: const QuranPlanScreen(),
      ),
      _ToolData(
        icon: Icons.auto_stories_rounded,
        label: AppLocale.format(AppLocale.moreJournal),
        color: AppColors.emerald600,
        screen: const JournalScreen(),
      ),
      _ToolData(
        icon: Icons.place_rounded,
        label: AppLocale.format(AppLocale.moreMosques),
        color: AppColors.warning,
        screen: const MosqueScreen(),
      ),
      _ToolData(
        icon: Icons.calculate_rounded,
        label: AppLocale.format(AppLocale.moreToolZakatAI),
        color: AppColors.primary,
        screen: const AIZakatScreen(),
      ),
      _ToolData(
        icon: Icons.settings_rounded,
        label: AppLocale.format(AppLocale.moreSettings),
        color: isDark ? AppColors.slate300 : AppColors.slate600,
        screen: const SettingsScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.navMore),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.slate800,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocale.format(AppLocale.moreTitle),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isDark ? AppColors.slate300 : AppColors.slate600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: tools.length,
                  itemBuilder: (context, index) => ToolGridItem(
                    icon: tools[index].icon,
                    label: tools[index].label,
                    color: tools[index].color,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => tools[index].screen),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolData {
  final IconData icon;
  final String label;
  final Color color;
  final Widget screen;

  const _ToolData({
    required this.icon,
    required this.label,
    required this.color,
    required this.screen,
  });
}
