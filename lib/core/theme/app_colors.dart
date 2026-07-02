import 'package:flutter/material.dart';

/// App color constants matching the HTML design
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF047857); // Deep Professional Islamic Emerald Green (High Contrast)
  static const Color gold = Color(0xFFD4AF37);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF6F8F7);
  static const Color backgroundDark = Color(0xFF102218);

  // Emerald Shades
  static const Color emerald50 = Color(0xFFECFDF5);
  static const Color emerald100 = Color(0xFFD1FAE5);
  static const Color emerald600 = Color(0xFF059669);
  static const Color emerald700 = Color(0xFF047857);
  static const Color emerald800 = Color(0xFF065F46);
  static const Color emerald900 = Color(0xFF064E3B);
  static const Color emerald950 = Color(0xFF022C22);

  // Slate Shades
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // Semantic Colors
  static const Color success = primary;
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Opacity helpers
  static Color primaryWith10 = primary.withValues(alpha: 0.1);
  static Color primaryWith20 = primary.withValues(alpha: 0.2);
  static Color whiteWith10 = Colors.white.withValues(alpha: 0.1);
  static Color whiteWith20 = Colors.white.withValues(alpha: 0.2);
  static Color whiteWith80 = Colors.white.withValues(alpha: 0.8);
}
