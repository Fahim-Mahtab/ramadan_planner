import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/countdown_item.dart';

class CountdownProvider extends ChangeNotifier {
  Timer? _timer;
  DateTime _now = DateTime.now();

  final List<CountdownItem> _items = [
    CountdownItem(
      title: 'countdownUntilRamadan',
      targetDate: DateTime(2026, 2, 18),
      icon: Icons.nightlight_round,
      color: AppColors.primary,
    ),
    CountdownItem(
      title: 'countdownUntilEid',
      targetDate: DateTime(2026, 3, 20),
      icon: Icons.celebration_rounded,
      color: AppColors.gold,
    ),
    CountdownItem(
      title: 'countdownUntilEid',
      targetDate: DateTime(2026, 5, 27),
      icon: Icons.card_giftcard_rounded,
      color: AppColors.emerald600,
    ),
    CountdownItem(
      title: 'countdownUntilEvent',
      targetDate: DateTime(2026, 5, 26),
      icon: Icons.nightlight_round,
      color: AppColors.warning,
    ),
  ];

  DateTime get now => _now;
  List<CountdownItem> get items => _items;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _now = DateTime.now();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
