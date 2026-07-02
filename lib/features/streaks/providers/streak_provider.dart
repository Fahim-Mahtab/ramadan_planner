import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakProvider with ChangeNotifier {
  bool _isInitialized = false;

  int _salahStreak = 0;
  int _checklistStreak = 0;
  int _quranStreak = 0;

  bool get isInitialized => _isInitialized;
  int get salahStreak => _salahStreak;
  int get checklistStreak => _checklistStreak;
  int get quranStreak => _quranStreak;

  int get bestStreak => [_salahStreak, _checklistStreak, quranStreak].reduce((a, b) => a > b ? a : b);

  Future<void> init() async {
    await Future.wait([
      _calcSalahStreak(),
      _calcChecklistStreak(),
      _calcQuranStreak(),
    ]);
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _calcSalahStreak() async {
    final prefs = await SharedPreferences.getInstance();
    var streak = 0;
    for (var i = 0; i < 90; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final key = DateFormat('yyyy_MM_dd').format(date);
      var allPrayed = true;
      for (var p = 0; p < 6; p++) {
        final val = prefs.getBool('salah_${key}_$p');
        if (val != true) {
          allPrayed = false;
          break;
        }
      }
      if (allPrayed) {
        streak++;
      } else {
        break;
      }
    }
    _salahStreak = streak;
  }

  Future<void> _calcChecklistStreak() async {
    final prefs = await SharedPreferences.getInstance();
    var streak = 0;
    for (var i = 0; i < 90; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final oldKey = 'checklist_${DateFormat('yyyy_MM_dd').format(date)}';
      final aiKey = 'ai_sunnah_${DateFormat('yyyy_MM_dd').format(date)}';
      
      final oldData = prefs.getString(oldKey);
      final aiData = prefs.getString(aiKey);
      
      if (oldData != null || aiData != null) {
        streak++;
      } else {
        break;
      }
    }
    _checklistStreak = streak;
  }

  Future<void> _calcQuranStreak() async {
    final prefs = await SharedPreferences.getInstance();
    var streak = 0;
    for (var i = 0; i < 90; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final key = 'quran_${DateFormat('yyyy_MM_dd').format(date)}';
      final data = prefs.getString(key);
      if (data != null) {
        streak++;
      } else {
        break;
      }
    }
    _quranStreak = streak;
  }

  Future<void> refresh() async {
    await init();
  }
}
