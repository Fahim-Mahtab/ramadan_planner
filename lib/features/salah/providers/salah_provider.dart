import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/salah_model.dart';
import '../../../core/constants/app_constants.dart';

/// Provider for managing Salah (prayer) state
class SalahProvider with ChangeNotifier {
  List<SalahModel> _prayers = [];
  bool _isLoading = true;

  SalahProvider() {
    _initializePrayers();
  }

  List<SalahModel> get prayers => _prayers;
  bool get isLoading => _isLoading;

  int get completedCount => _prayers.where((p) => p.isCompleted).length;

  int get totalCount => _prayers.length;

  String get _currentDateKey => DateFormat('yyyy_MM_dd').format(DateTime.now());

  Future<void> _initializePrayers() async {
    _prayers = AppConstants.prayerNames
        .map((name) => SalahModel(name: name))
        .toList();

    final prefs = await SharedPreferences.getInstance();
    final dateKey = _currentDateKey;

    for (int i = 0; i < _prayers.length; i++) {
      bool? isCompleted = prefs.getBool('salah_${dateKey}_$i');
      if (isCompleted != null) {
        _prayers[i].isCompleted = isCompleted;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> togglePrayer(int index) async {
    if (index >= 0 && index < _prayers.length) {
      _prayers[index].toggle();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
        'salah_${_currentDateKey}_$index',
        _prayers[index].isCompleted,
      );
    }
  }

  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    final dateKey = _currentDateKey;
    for (int i = 0; i < _prayers.length; i++) {
      _prayers[i].isCompleted = false;
      await prefs.setBool('salah_${dateKey}_$i', false);
    }
    notifyListeners();
  }
}
