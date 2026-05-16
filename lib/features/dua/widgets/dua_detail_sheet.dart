import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../models/dua_model.dart';
import '../providers/dua_provider.dart';
import 'tasbih_counter.dart';

class DuaDetailSheet extends StatelessWidget {
  final DuaModel dua;
  const DuaDetailSheet({super.key, required this.dua});

  static void show(BuildContext context, DuaModel dua) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DuaDetailSheet(dua: dua),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langCode = FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isDark, langCode),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildArabicSection(isDark),
                    const SizedBox(height: 20),
                    _buildDivider(isDark),
                    const SizedBox(height: 20),
                    _buildPronunciationSection(context, isDark, langCode),
                    const SizedBox(height: 16),
                    _buildTranslationSection(context, isDark, langCode),
                    const SizedBox(height: 16),
                    _buildReference(isDark),
                    if (dua.tasbihTarget > 0) ...[
                      const SizedBox(height: 24),
                      _buildDivider(isDark),
                      const SizedBox(height: 16),
                      _buildTasbihSection(context),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPronunciationSection(
      BuildContext context, bool isDark, String langCode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocale.format(AppLocale.duaDetailPronunciation),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            dua.getPronounciation(langCode),
            style: TextStyle(
              fontSize: 15,
              height: 1.7,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : AppColors.slate800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, String langCode) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            dua.group.accentColor.withValues(alpha: isDark ? 0.3 : 0.1),
            isDark
                ? AppColors.emerald900.withValues(alpha: 0.2)
                : const Color(0xFFECFDF5).withValues(alpha: 0.5),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.slate600 : AppColors.slate300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dua.group.accentColor.withValues(alpha: 0.15),
                ),
                child: Icon(dua.icon, color: dua.group.accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dua.getName(langCode),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.slate800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dua.group.getLabel(langCode),
                      style: TextStyle(
                        fontSize: 12,
                        color: dua.group.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButtons(context, isDark, langCode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, bool isDark, String langCode) {
    return Consumer<DuaProvider>(
      builder: (context, provider, _) {
        final isFav = provider.isFavorite(dua.id);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionIcon(
              icon: isFav
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFav ? AppColors.error : null,
              isDark: isDark,
              onTap: () => provider.toggleFavorite(dua.id),
            ),
            _ActionIcon(
              icon: Icons.copy_rounded,
              isDark: isDark,
              onTap: () {
                final String p = AppLocale.format(AppLocale.duaDetailPronunciation);
                final String t = AppLocale.format(AppLocale.duaDetailTranslation);
                final text =
                    '${dua.arabic}\n\n$p: ${dua.getPronounciation(langCode)}\n\n$t: ${dua.getTranslation(langCode)}\n\n— ${dua.reference}';
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        AppLocale.format(AppLocale.duaDetailCopied)),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildArabicSection(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.emerald900.withValues(alpha: 0.2)
            : const Color(0xFFFFFBEB).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: AppColors.gold, width: 4),
        ),
      ),
      child: Text(
        dua.arabic,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: AppTheme.arabicTextStyle(
          fontSize: 26,
          color: isDark ? const Color(0xFFD1FAE5) : AppColors.emerald900,
        ).copyWith(height: 1.9, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? AppColors.slate700 : AppColors.slate300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.diamond_rounded,
            size: 10,
            color: AppColors.gold.withValues(alpha: 0.6),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? AppColors.slate700 : AppColors.slate300,
          ),
        ),
      ],
    );
  }

  Widget _buildTranslationSection(
      BuildContext context, bool isDark, String langCode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.slate800.withValues(alpha: 0.5)
            : AppColors.slate50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocale.format(AppLocale.duaDetailTranslation),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: isDark ? AppColors.slate400 : AppColors.slate500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            dua.getTranslation(langCode),
            style: TextStyle(
              fontSize: 15,
              height: 1.7,
              color: isDark ? AppColors.slate300 : AppColors.slate700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReference(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.slate800.withValues(alpha: 0.5)
            : AppColors.slate100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_rounded,
              size: 14,
              color: isDark ? AppColors.slate400 : AppColors.slate500),
          const SizedBox(width: 6),
          Text(
            dua.reference,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.slate400 : AppColors.slate500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasbihSection(BuildContext context) {
    return Consumer<DuaProvider>(
      builder: (context, provider, _) => Center(
        child: TasbihCounter(
          count: provider.getTasbihCount(dua.id),
          target: dua.tasbihTarget,
          onTap: () => provider.incrementTasbih(dua.id),
          onReset: () => provider.resetTasbih(dua.id),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        margin: const EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? AppColors.slate800.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: color ?? (isDark ? AppColors.slate300 : AppColors.slate600),
        ),
      ),
    );
  }
}
