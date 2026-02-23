import 'package:flutter/foundation.dart';
import '../models/salah_model.dart';
import '../../../core/constants/app_constants.dart';

/// Provider for managing Salah (prayer) state
class SalahProvider with ChangeNotifier {
  List<SalahModel> _prayers = [];

  SalahProvider() {
    _initializePrayers();
  }

  List<SalahModel> get prayers => _prayers;

  int get completedCount => _prayers.where((p) => p.isCompleted).length;

  int get totalCount => _prayers.length;

  String get completionStatus => '$completedCount/$totalCount Done';

  void _initializePrayers() {
    _prayers = AppConstants.prayerNames
        .map((name) => SalahModel(name: name))
        .toList();

    // Mock data: Mark first 4 prayers as completed
    _prayers[0].isCompleted = true; // Fajr
    _prayers[1].isCompleted = true; // Dhuhr
    _prayers[2].isCompleted = true; // Asr
    _prayers[3].isCompleted = true; // Maghrib
  }

  void togglePrayer(int index) {
    if (index >= 0 && index < _prayers.length) {
      _prayers[index].toggle();
      notifyListeners();
    }
  }

  void resetAll() {
    for (var prayer in _prayers) {
      prayer.isCompleted = false;
    }
    notifyListeners();
  }
}
