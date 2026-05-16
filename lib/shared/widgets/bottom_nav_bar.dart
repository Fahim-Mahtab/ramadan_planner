import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/l10n/app_locale.dart';
import '../../core/theme/app_colors.dart';

/// Bottom navigation bar with iOS-style blur effect
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: (isDark
                ? AppColors.slate900.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.8)),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? AppColors.emerald900.withValues(alpha: 0.3)
                    : const Color(0xFFD1FAE5), // emerald-100
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: AppLocale.format(AppLocale.navHome),
                    isActive: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    icon: Icons.menu_book_rounded,
                    label: AppLocale.format(AppLocale.navQuran),
                    isActive: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  _NavItem(
                    icon: Icons.schedule_rounded,
                    label: AppLocale.format(AppLocale.navTimes),
                    isActive: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  _NavItem(
                    icon: Icons.volunteer_activism_rounded,
                    label: AppLocale.format(AppLocale.navDua),
                    isActive: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  _NavItem(
                    icon: Icons.mosque_rounded,
                    label: AppLocale.format(AppLocale.navCommunity),
                    isActive: currentIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppColors.primary
                  : (isDark ? AppColors.slate500 : AppColors.slate400),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? AppColors.primary
                    : (isDark ? AppColors.slate500 : AppColors.slate400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
