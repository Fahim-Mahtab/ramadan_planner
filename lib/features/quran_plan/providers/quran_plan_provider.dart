import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reading_plan.dart';

class QuranPlanProvider with ChangeNotifier {
  ReadingPlan _plan = const ReadingPlan();
  List<DailyReading> _dailyReadings = [];
  bool _isInitialized = false;

  ReadingPlan get plan => _plan;
  List<DailyReading> get dailyReadings => _dailyReadings;
  bool get isInitialized => _isInitialized;

  int get todayPagesRead {
    final key = DateFormat('yyyy_MM_dd').format(DateTime.now());
    return _dailyReadings.where((r) => r.dateKey == key).fold(0, (sum, r) => sum + r.pagesRead);
  }

  int get todayTarget => _plan.dailyTargetPages;

  bool get todayCompleted => todayPagesRead >= todayTarget;

  int get thisMonthPages {
    final now = DateTime.now();
    return _dailyReadings
        .where((r) => r.date.month == now.month && r.date.year == now.year)
        .fold(0, (sum, r) => sum + r.pagesRead);
  }

  int get thisMonthDaysCompleted {
    final now = DateTime.now();
    return _dailyReadings
        .where((r) => r.date.month == now.month && r.date.year == now.year && r.completed)
        .length;
  }

  double get monthlyProgress {
    final totalNeeded = _plan.monthlyTargetJuz * 20;
    return totalNeeded > 0 ? (thisMonthPages / totalNeeded).clamp(0.0, 1.0) : 0.0;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();

    final planData = prefs.getString('quran_plan');
    if (planData != null) {
      try {
        _plan = ReadingPlan.fromJson(json.decode(planData));
      } catch (_) {
        _plan = const ReadingPlan();
      }
    }

    final readingsData = prefs.getString('quran_plan_readings');
    if (readingsData != null) {
      try {
        final list = json.decode(readingsData) as List;
        _dailyReadings = list.map((e) {
          final m = e as Map<String, dynamic>;
          return DailyReading(
            date: DateTime.parse('${m['dateKey']?.toString().replaceAll('_', '-')}'),
            dateKey: m['dateKey'] as String,
            pagesRead: m['pagesRead'] as int? ?? 0,
            targetPages: m['targetPages'] as int? ?? _plan.dailyTargetPages,
            completed: m['completed'] as bool? ?? false,
          );
        }).toList();
      } catch (_) {
        _dailyReadings = [];
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quran_plan', json.encode(_plan.toJson()));
    await prefs.setString('quran_plan_readings',
        json.encode(_dailyReadings.map((r) => r.toJson()).toList()));
  }

  Future<void> updatePlan(ReadingPlan plan) async {
    _plan = plan;
    notifyListeners();
    await _persist();
  }

  Future<void> logReading(int pages) async {
    final key = DateFormat('yyyy_MM_dd').format(DateTime.now());
    final existing = _dailyReadings.indexWhere((r) => r.dateKey == key);
    final today = DateTime.now();

    if (existing >= 0) {
      final totalPages = _dailyReadings[existing].pagesRead + pages;
      _dailyReadings[existing] = _dailyReadings[existing].copyWith(
        pagesRead: totalPages,
        completed: totalPages >= _plan.dailyTargetPages,
      );
    } else {
      _dailyReadings.add(DailyReading(
        date: today,
        dateKey: key,
        pagesRead: pages,
        targetPages: _plan.dailyTargetPages,
        completed: pages >= _plan.dailyTargetPages,
      ));
    }

    notifyListeners();
    await _persist();
  }
}
