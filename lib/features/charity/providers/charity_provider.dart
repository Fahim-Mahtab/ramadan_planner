import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/charity_record.dart';

class CharityProvider with ChangeNotifier {
  List<CharityRecord> _records = [];
  bool _isInitialized = false;

  List<CharityRecord> get records => _records;
  bool get isInitialized => _isInitialized;

  double get totalGiven =>
      _records.fold(0.0, (sum, r) => sum + r.amount);

  double get thisMonthTotal {
    final now = DateTime.now();
    return _records
        .where((r) => r.date.month == now.month && r.date.year == now.year)
        .fold(0.0, (sum, r) => sum + r.amount);
  }

  int get thisMonthCount {
    final now = DateTime.now();
    return _records
        .where((r) => r.date.month == now.month && r.date.year == now.year)
        .length;
  }

  Map<CharityCategory, double> get categoryTotals {
    final map = <CharityCategory, double>{};
    for (final r in _records) {
      map[r.category] = (map[r.category] ?? 0) + r.amount;
    }
    return map;
  }

  double get averagePerDay {
    if (_records.isEmpty) return 0;
    final days = _records.map((r) => r.dateKey).toSet().length;
    return days > 0 ? totalGiven / days : 0;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('charity_records');
    if (data != null) {
      try {
        final list = json.decode(data) as List;
        _records = list.map((e) => CharityRecord.fromJson(e)).toList();
      } catch (_) {
        _records = [];
      }
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_records.map((r) => r.toJson()).toList());
    await prefs.setString('charity_records', encoded);
  }

  Future<void> addRecord(CharityRecord record) async {
    _records.insert(0, record);
    notifyListeners();
    await _persist();
  }

  Future<void> deleteRecord(String id) async {
    _records.removeWhere((r) => r.id == id);
    notifyListeners();
    await _persist();
  }
}
