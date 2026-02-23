import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Reusable card widget with consistent styling
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? borderWidth;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.slate900.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              borderColor ??
              (isDark
                  ? AppColors.emerald900.withValues(alpha: 0.2)
                  : const Color(0xFFF0FDF4)), // emerald-50
          width: borderWidth ?? 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
