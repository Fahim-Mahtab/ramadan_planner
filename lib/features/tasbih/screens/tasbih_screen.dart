import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/tasbih_provider.dart';
import '../widgets/dhikr_selector.dart';
import '../widgets/tasbih_display.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TasbihProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.tasbihTitle),
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
            icon: Icon(
              Icons.refresh_rounded,
              color: isDark ? AppColors.slate400 : AppColors.slate500,
            ),
            onPressed: () => _showResetDialog(context),
          ),
        ],
      ),
      body: Consumer<TasbihProvider>(
        builder: (context, provider, _) {
          if (!provider.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          final dhikr = provider.currentDhikr;

          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  dhikr.transliteration,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.slate800,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    dhikr.translationEn,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.slate400 : AppColors.slate500,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const TasbihDisplay(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionButton(
                      icon: Icons.remove_rounded,
                      onTap: provider.decrement,
                    ),
                    const SizedBox(width: 48),
                    _ActionButton(
                      icon: Icons.exposure_zero_rounded,
                      onTap: provider.reset,
                    ),
                  ],
                ),
                const Spacer(),
                const DhikrSelector(),
                const SizedBox(height: 24),
                Text(
                  AppLocale.format(AppLocale.tasbihTodaySummary, replace: {'total': '${provider.totalTasbihToday}', 'completed': '${provider.completedDhikr}', 'all': '${provider.records.length}'}),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.slate500 : AppColors.slate400,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocale.format(AppLocale.tasbihResetAllTitle)),
        content: Text(AppLocale.format(AppLocale.tasbihResetAllMessage)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocale.format(AppLocale.tasbihCancel)),
          ),
          TextButton(
            onPressed: () {
              context.read<TasbihProvider>().resetAll();
              HapticFeedback.mediumImpact();
              Navigator.pop(ctx);
            },
            child: Text(AppLocale.format(AppLocale.tasbihReset)),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate800 : AppColors.slate100,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? AppColors.slate700 : AppColors.slate200,
          ),
        ),
        child: Icon(
          icon,
          color: isDark ? AppColors.slate300 : AppColors.slate600,
          size: 24,
        ),
      ),
    );
  }
}
