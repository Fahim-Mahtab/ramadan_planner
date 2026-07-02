import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fasting_record.dart';

class FastingProvider with ChangeNotifier {
  Map<String, FastingRecord> _records = {};
  bool _isInitialized = false;

  Map<String, FastingRecord> get records => _records;
  bool get isInitialized => _isInitialized;

  int get currentMonthFasts {
    final now = DateTime.now();
    return _records.values.where((r) {
      return r.date.year == now.year && r.date.month == now.month && r.status == FastStatus.kept;
    }).length;
  }

  int get totalFastsThisYear {
    final now = DateTime.now();
    return _records.values.where((r) {
      return r.date.year == now.year && r.status == FastStatus.kept;
    }).length;
  }

  int get currentStreak {
    var streak = 0;
    var day = DateTime.now();
    while (true) {
      final key = FastingRecord(date: day, type: FastType.voluntary, status: FastStatus.kept).dateKey;
      final record = _records[key];
      if (record != null && record.status == FastStatus.kept) {
        streak++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  int get longestStreak {
    final sortedDates = _records.values
        .where((r) => r.status == FastStatus.kept)
        .map((r) => r.date)
        .toList()
      ..sort();
    if (sortedDates.isEmpty) return 0;
    var maxStreak = 1;
    var current = 1;
    for (var i = 1; i < sortedDates.length; i++) {
      if (sortedDates[i].difference(sortedDates[i - 1]).inDays == 1) {
        current++;
        maxStreak = current > maxStreak ? current : maxStreak;
      } else {
        current = 1;
      }
    }
    return maxStreak;
  }

  FastStatus? getStatus(DateTime date) {
    final key = FastingRecord(date: date, type: FastType.voluntary, status: FastStatus.kept).dateKey;
    return _records[key]?.status;
  }

  FastType? getType(DateTime date) {
    final key = FastingRecord(date: date, type: FastType.voluntary, status: FastStatus.kept).dateKey;
    return _records[key]?.type;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('fasting_records');
    if (data != null) {
      try {
        final map = json.decode(data) as Map<String, dynamic>;
        _records = map.map((k, v) => MapEntry(k, FastingRecord.fromJson(v)));
      } catch (_) {
        _records = {};
      }
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final map = _records.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString('fasting_records', json.encode(map));
  }

  Future<void> toggleDay(DateTime date, FastType type) async {
    final key = FastingRecord(date: date, type: type, status: FastStatus.kept).dateKey;
    final existing = _records[key];
    if (existing != null) {
      if (existing.status == FastStatus.kept) {
        _records[key] = existing.copyWith(status: FastStatus.missed);
      } else {
        _records[key] = existing.copyWith(status: FastStatus.kept);
      }
    } else {
      _records[key] = FastingRecord(date: date, type: type, status: FastStatus.kept);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> markMakeup(DateTime date, {FastType type = FastType.makeup}) async {
    final key = FastingRecord(date: date, type: type, status: FastStatus.kept).dateKey;
    _records[key] = FastingRecord(date: date, type: type, status: FastStatus.kept);
    notifyListeners();
    await _persist();
  }
}
