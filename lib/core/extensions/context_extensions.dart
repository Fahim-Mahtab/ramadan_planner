import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

extension RamadanContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get surfaceColor => isDark ? AppColors.slate900 : Colors.white;

  Color get textPrimary => isDark ? Colors.white : AppColors.slate800;

  Color get textSecondary => isDark ? AppColors.slate300 : AppColors.slate600;

  Color get textTertiary => isDark ? AppColors.slate500 : AppColors.slate400;

  Color get borderColor =>
      isDark ? AppColors.emerald900.withAlpha(77) : const Color(0xFFD1FAE5);

  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;
  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;
  TextStyle? get displaySmall => Theme.of(this).textTheme.displaySmall;
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;
  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;
}
