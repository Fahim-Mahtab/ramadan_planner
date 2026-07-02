import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/l10n/app_locale.dart';
import '../providers/ai_dua_provider.dart';

class AIDuaRecommenderScreen extends StatefulWidget {
  const AIDuaRecommenderScreen({super.key});

  @override
  State<AIDuaRecommenderScreen> createState() => _AIDuaRecommenderScreenState();
}

class _AIDuaRecommenderScreenState extends State<AIDuaRecommenderScreen> {
  final TextEditingController _customEmotionController = TextEditingController();

  void _fetchDua(String emotion) {
    context.read<AIDuaProvider>().fetchDuaRecommendation(emotion);
    _customEmotionController.clear();
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocale.format(AppLocale.aiDuaTitle),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.slate800,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : AppColors.slate800,
        ),
      ),
      body: Consumer<AIDuaProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocale.format(AppLocale.aiDuaHint),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    AppLocale.format(AppLocale.aiDuaFeelingAnxious),
                    AppLocale.format(AppLocale.aiDuaFeelingGrateful),
                    AppLocale.format(AppLocale.aiDuaFeelingSad),
                  ].map((emotion) {
                    return ActionChip(
                      label: Text(emotion),
                      backgroundColor: isDark ? AppColors.slate800 : AppColors.slate100,
                      labelStyle: TextStyle(
                        color: isDark ? Colors.white : AppColors.slate800,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () => _fetchDua(emotion),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _customEmotionController,
                        decoration: InputDecoration(
                          hintText: AppLocale.format(AppLocale.aiDuaHint),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: isDark ? AppColors.slate800 : AppColors.slate100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onSubmitted: _fetchDua,
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 24,
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                        onPressed: () => _fetchDua(_customEmotionController.text),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: _buildResultArea(context, provider, isDark),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultArea(BuildContext context, AIDuaProvider provider, bool isDark) {
    if (provider.isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(AppLocale.format(AppLocale.aiAssistantTyping)),
          ],
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Text(
          provider.error!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (provider.recommendedDua == null) {
      return Center(
        child: Icon(
          Icons.favorite_outline_rounded,
          size: 80,
          color: isDark ? AppColors.slate800 : AppColors.slate200,
        ),
      );
    }

    final dua = provider.recommendedDua!;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate800 : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Column(
          children: [
            if (dua.arabicText.isNotEmpty) ...[
              Text(
                dua.arabicText,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  fontFamily: 'Amiri', // Optional Arabic font
                ),
              ),
              const SizedBox(height: 24),
            ],
            if (dua.transliteration.isNotEmpty) ...[
              Text(
                AppLocale.format(AppLocale.duaDetailPronunciation),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                dua.transliteration,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : AppColors.slate700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (dua.translation.isNotEmpty) ...[
              Text(
                AppLocale.format(AppLocale.duaDetailTranslation),
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                dua.translation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white : AppColors.slate800,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
            ],
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dua.explanation,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.slate300 : AppColors.slate600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
