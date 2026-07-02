import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n/app_locale.dart';
import '../providers/ai_quran_plan_provider.dart';

class AIQuranPlanSetupDialog extends StatefulWidget {
  const AIQuranPlanSetupDialog({super.key});

  @override
  State<AIQuranPlanSetupDialog> createState() => _AIQuranPlanSetupDialogState();
}

class _AIQuranPlanSetupDialogState extends State<AIQuranPlanSetupDialog> {
  int _daysLeft = 30;
  int _minutesPerDay = 30;
  String _readingSpeedKey = AppLocale.aiQuranPlanSpeedAverage;

  final List<String> _speedKeys = [
    AppLocale.aiQuranPlanSpeedSlow,
    AppLocale.aiQuranPlanSpeedAverage,
    AppLocale.aiQuranPlanSpeedFast,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? AppColors.slate900 : Colors.white,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Consumer<AIQuranPlanProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return _buildLoadingState(isDark);
            }
            if (provider.generatedPlan != null) {
              return _buildResultState(context, provider, isDark);
            }
            return _buildFormState(context, provider, isDark);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            AppLocale.format(AppLocale.aiQuranPlanGenerating),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultState(BuildContext context, AIQuranPlanProvider provider, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocale.format(AppLocale.aiQuranPlanResultTitle),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.slate900,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                provider.clearPlan();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        const Divider(),
        Expanded(
          child: Markdown(
            data: provider.generatedPlan ?? "",
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(color: isDark ? AppColors.slate300 : AppColors.slate700, fontSize: 15),
              h1: TextStyle(color: isDark ? Colors.white : Colors.black),
              h2: TextStyle(color: isDark ? Colors.white : Colors.black),
              h3: TextStyle(color: isDark ? Colors.white : Colors.black),
              listBullet: TextStyle(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => provider.clearPlan(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(AppLocale.format(AppLocale.aiQuranPlanNewBtn)),
          ),
        ),
      ],
    );
  }

  Widget _buildFormState(BuildContext context, AIQuranPlanProvider provider, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocale.format(AppLocale.aiQuranPlanTitle),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.slate900,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (provider.error != null) ...[
          Text(provider.error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
        ],
        _buildLabel("${AppLocale.format(AppLocale.aiQuranPlanDaysLeft)}: $_daysLeft", isDark),
        Slider(
          value: _daysLeft.toDouble(),
          min: 1,
          max: 30,
          divisions: 29,
          activeColor: AppColors.primary,
          label: _daysLeft.toString(),
          onChanged: (val) => setState(() => _daysLeft = val.toInt()),
        ),
        const SizedBox(height: 16),
        _buildLabel("${AppLocale.format(AppLocale.aiQuranPlanMins)}: $_minutesPerDay", isDark),
        Slider(
          value: _minutesPerDay.toDouble(),
          min: 10,
          max: 180,
          divisions: 17,
          activeColor: AppColors.primary,
          label: _minutesPerDay.toString(),
          onChanged: (val) => setState(() => _minutesPerDay = val.toInt()),
        ),
        const SizedBox(height: 16),
        _buildLabel(AppLocale.format(AppLocale.aiQuranPlanSpeed), isDark),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.slate800 : AppColors.slate100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _readingSpeedKey,
              isExpanded: true,
              dropdownColor: isDark ? AppColors.slate800 : Colors.white,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: _speedKeys.map((key) {
                return DropdownMenuItem(
                  value: key,
                  child: Text(AppLocale.format(key)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _readingSpeedKey = val);
              },
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              provider.generatePlan(
                daysLeft: _daysLeft,
                minutesPerDay: _minutesPerDay,
                readingSpeed: AppLocale.format(_readingSpeedKey),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(AppLocale.format(AppLocale.aiQuranPlanGenerateBtn), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : AppColors.slate800,
      ),
    );
  }
}
