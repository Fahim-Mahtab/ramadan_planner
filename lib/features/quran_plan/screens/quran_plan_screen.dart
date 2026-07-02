import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n/app_locale.dart';
import '../models/reading_plan.dart';
import '../providers/quran_plan_provider.dart';
import '../widgets/ai_quran_plan_setup_dialog.dart';

class QuranPlanScreen extends StatefulWidget {
  const QuranPlanScreen({super.key});

  @override
  State<QuranPlanScreen> createState() => _QuranPlanScreenState();
}

class _QuranPlanScreenState extends State<QuranPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranPlanProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.quranPlanTitle),
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
            icon: Icon(Icons.settings_rounded, color: isDark ? AppColors.slate400 : AppColors.slate500),
            onPressed: () => _showPlanSettings(context),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton.extended(
          heroTag: 'quran_plan_fab',
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AIQuranPlanSetupDialog(),
            );
          },
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.smart_toy_rounded, color: Colors.white),
          label: Text(AppLocale.format(AppLocale.quranPlanFabAI), style: const TextStyle(color: Colors.white)),
        ),
      ),
      body: Consumer<QuranPlanProvider>(
        builder: (context, provider, _) {
          if (!provider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TodayCard(provider: provider, isDark: isDark),
                const SizedBox(height: 24),
                _MonthlyCard(provider: provider, isDark: isDark),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocale.format(AppLocale.quranPlanRecent),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.slate800,
                      ),
                    ),
                    if (provider.todayPagesRead > 0)
                      TextButton(
                        onPressed: () => _showLogDialog(context, provider),
                        child: Text(AppLocale.format(AppLocale.quranPlanLogMore)),
                      )
                    else
                      TextButton(
                        onPressed: () => _showLogDialog(context, provider),
                        child: Text(AppLocale.format(AppLocale.quranPlanLogToday)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (provider.dailyReadings.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.menu_book_rounded, size: 48,
                            color: isDark ? AppColors.slate500 : AppColors.slate300),
                        const SizedBox(height: 12),
                        Text(
                          AppLocale.format(AppLocale.quranPlanStartJourney),
                          style: TextStyle(
                            color: isDark ? AppColors.slate400 : AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...provider.dailyReadings.take(7).map((r) => _ReadingTile(
                        reading: r,
                        isDark: isDark,
                      )),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogDialog(BuildContext context, QuranPlanProvider provider) {
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocale.format(AppLocale.quranPlanLogReading)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: AppLocale.format(AppLocale.quranPlanPagesRead),
            hintText: AppLocale.format(AppLocale.quranPlanPagesHint),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocale.format(AppLocale.quranPlanCancel))),
          TextButton(
            onPressed: () {
              final pages = int.tryParse(ctrl.text);
              if (pages != null && pages > 0) {
                provider.logReading(pages);
                Navigator.pop(ctx);
              }
            },
            child: Text(AppLocale.format(AppLocale.quranPlanSave)),
          ),
        ],
      ),
    );
  }

  void _showPlanSettings(BuildContext context) {
    final provider = context.read<QuranPlanProvider>();
    final dailyCtrl = TextEditingController(text: provider.plan.dailyTargetPages.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocale.format(AppLocale.quranPlanSetTarget)),
        content: TextField(
          controller: dailyCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: AppLocale.format(AppLocale.quranPlanPagesPerDay),
            hintText: AppLocale.format(AppLocale.quranPlanPagesPerDayHint),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocale.format(AppLocale.cancel))),
          TextButton(
            onPressed: () {
              final pages = int.tryParse(dailyCtrl.text);
              if (pages != null && pages > 0) {
                provider.updatePlan(provider.plan.copyWith(dailyTargetPages: pages));
                Navigator.pop(ctx);
              }
            },
            child: Text(AppLocale.format(AppLocale.save)),
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  final QuranPlanProvider provider;
  final bool isDark;

  const _TodayCard({required this.provider, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final progress = (provider.todayPagesRead / provider.todayTarget).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withAlpha(25), AppColors.emerald600.withAlpha(20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocale.format(AppLocale.quranPlanTodayReading),
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                color: isDark ? AppColors.slate300 : AppColors.slate600),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${provider.todayPagesRead}',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.slate800),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  AppLocale.format(AppLocale.quranPlanPagesPerDay, replace: {'target': '${provider.todayTarget}'}),
                  style: TextStyle(fontSize: 16,
                      color: isDark ? AppColors.slate400 : AppColors.slate500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? AppColors.slate800 : Colors.white.withAlpha(150),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1 ? AppColors.primary : AppColors.gold,
              ),
              minHeight: 10,
            ),
          ),
          if (provider.todayCompleted)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(AppLocale.format(AppLocale.quranPlanTargetAchieved),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MonthlyCard extends StatelessWidget {
  final QuranPlanProvider provider;
  final bool isDark;

  const _MonthlyCard({required this.provider, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.slate700 : AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocale.format(AppLocale.quranPlanMonthlyProgress),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.slate800)),
          const SizedBox(height: 12),
          Row(
            children: [
              _MiniStat(label: AppLocale.format(AppLocale.quranPlanPagesReadStat), value: '${provider.thisMonthPages}', isDark: isDark),
              const SizedBox(width: 16),
              _MiniStat(label: AppLocale.format(AppLocale.quranPlanDaysCompleted), value: '${provider.thisMonthDaysCompleted}', isDark: isDark),
              const SizedBox(width: 16),
              _MiniStat(label: AppLocale.format(AppLocale.quranPlanDailyTarget), value: '${provider.plan.dailyTargetPages}p', isDark: isDark),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: provider.monthlyProgress,
              backgroundColor: isDark ? AppColors.slate800 : AppColors.slate100,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _MiniStat({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.slate800)),
          Text(label,
            style: TextStyle(fontSize: 10, color: isDark ? AppColors.slate400 : AppColors.slate500)),
        ],
      ),
    );
  }
}

class _ReadingTile extends StatelessWidget {
  final DailyReading reading;
  final bool isDark;

  const _ReadingTile({required this.reading, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate900 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? AppColors.slate700 : AppColors.slate200),
      ),
      child: Row(
        children: [
          Icon(
            reading.completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: reading.completed ? AppColors.primary : (isDark ? AppColors.slate500 : AppColors.slate400),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            reading.dateKey.replaceAll('_', '/'),
            style: TextStyle(fontSize: 12, color: isDark ? AppColors.slate300 : AppColors.slate600),
          ),
          const Spacer(),
          Text(
            AppLocale.format(AppLocale.quranPlanReadingFraction, replace: {'read': '${reading.pagesRead}', 'target': '${reading.targetPages}'}),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: reading.completed
                  ? AppColors.primary
                  : (isDark ? AppColors.slate400 : AppColors.slate500),
            ),
          ),
        ],
      ),
    );
  }
}
