import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/dua_provider.dart';
import 'dua_detail_sheet.dart';

class DuaCard extends StatelessWidget {
  const DuaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langCode =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';

    return Consumer<DuaProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const SizedBox.shrink();
        }

        final dua = provider.duaOfTheDay;

        return GestureDetector(
          onTap: () => DuaDetailSheet.show(context, dua),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.emerald900.withValues(alpha: 0.2)
                  : const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border(left: BorderSide(color: AppColors.gold, width: 4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded,
                        color: AppColors.gold, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      AppLocale.format(AppLocale.duaCardTitle).toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: isDark
                            ? const Color(0xFFA7F3D0)
                            : AppColors.emerald800,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: isDark ? AppColors.slate500 : AppColors.slate400,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  dua.arabic,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.arabicTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: isDark
                        ? const Color(0xFFD1FAE5)
                        : AppColors.emerald900,
                  ).copyWith(height: 1.6),
                ),
                const SizedBox(height: 12),
                Text(
                  dua.getPronounciation(langCode),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFF6EE7B7)
                        : const Color(0xFF047857),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
