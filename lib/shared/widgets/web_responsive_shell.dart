import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class WebResponsiveShell extends StatelessWidget {
  final Widget child;
  const WebResponsiveShell({super.key, required this.child});

  static const double _maxWidth = 480;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= _maxWidth) {
          return child;
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          color: isDark
              ? const Color(0xFF0A1A12)
              : const Color(0xFFE8F5E9),
          child: Center(
            child: Container(
              width: _maxWidth,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                    blurRadius: 32,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
