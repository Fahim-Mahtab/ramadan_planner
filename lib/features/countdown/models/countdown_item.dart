import 'package:flutter/material.dart';

class CountdownItem {
  final String title;
  final DateTime targetDate;
  final IconData icon;
  final Color color;

  const CountdownItem({
    required this.title,
    required this.targetDate,
    required this.icon,
    required this.color,
  });

  Duration get remaining => targetDate.difference(DateTime.now());
  int get days => remaining.inDays;
  int get hours => remaining.inHours % 24;
  int get minutes => remaining.inMinutes % 60;
  int get seconds => remaining.inSeconds % 60;

  double progress(DateTime now) {
    final start = targetDate.subtract(const Duration(days: 365));
    final total = targetDate.difference(start).inSeconds;
    final elapsed = now.difference(start).inSeconds;
    if (total <= 0) return 0;
    return (elapsed / total).clamp(0.0, 1.0);
  }
}
