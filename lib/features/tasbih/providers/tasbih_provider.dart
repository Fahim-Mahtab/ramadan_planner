import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dhikr_list.dart';
import '../models/tasbih_record.dart';

class TasbihProvider with ChangeNotifier {
  List<TasbihRecord> _records = [];
  int _selectedIndex = 0;
  bool _isInitialized = false;

  List<TasbihRecord> get records => _records;
  int get selectedIndex => _selectedIndex;
  DhikrItem get currentDhikr => allDhikr[_selectedIndex];
  bool get isInitialized => _isInitialized;
  int get totalTasbihToday =>
      _records.fold(0, (sum, r) => sum + (r.count >= r.target ? r.target : r.count));
  int get completedDhikr => _records.where((r) => r.isComplete).length;

  String get _storageKey => 'tasbih_records';

  Future<void> init() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);
    if (data != null) {
      try {
        final list = json.decode(data) as List;
        _records = list.map((e) => TasbihRecord.fromJson(e)).toList();
      } catch (_) {
        _records = allDhikr.map((d) => TasbihRecord(dhikrId: d.id, count: 0, target: d.target)).toList();
      }
    } else {
      _records = allDhikr.map((d) => TasbihRecord(dhikrId: d.id, count: 0, target: d.target)).toList();
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, json.encode(_records.map((r) => r.toJson()).toList()));
  }

  void selectDhikr(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> increment() async {
    final record = _records[_selectedIndex];
    if (record.isComplete) {
      _records[_selectedIndex] = record.copyWith(count: 0);
    } else {
      _records[_selectedIndex] = record.copyWith(count: record.count + 1);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> decrement() async {
    final record = _records[_selectedIndex];
    if (record.count > 0) {
      _records[_selectedIndex] = record.copyWith(count: record.count - 1);
      notifyListeners();
      await _persist();
    }
  }

  Future<void> reset() async {
    _records[_selectedIndex] = _records[_selectedIndex].copyWith(count: 0);
    notifyListeners();
    await _persist();
  }

  Future<void> resetAll() async {
    _records = _records.map((r) => r.copyWith(count: 0)).toList();
    notifyListeners();
    await _persist();
  }
}
