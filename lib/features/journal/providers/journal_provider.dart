import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';

class JournalProvider with ChangeNotifier {
  List<JournalEntry> _entries = [];
  bool _isInitialized = false;

  List<JournalEntry> get entries => _entries;
  bool get isInitialized => _isInitialized;

  int get totalEntries => _entries.length;

  List<JournalEntry> get recentEntries =>
      _entries.take(5).toList();

  List<JournalEntry> entriesForDate(DateTime date) {
    final key = '${date.year}_${date.month.toString().padLeft(2, '0')}_${date.day.toString().padLeft(2, '0')}';
    return _entries.where((e) => e.dateKey == key).toList();
  }

  bool hasEntryForDate(DateTime date) => entriesForDate(date).isNotEmpty;

  Future<void> init() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('journal_entries');
    if (data != null) {
      try {
        final list = json.decode(data) as List;
        _entries = list.map((e) => JournalEntry.fromJson(e)).toList();
      } catch (_) {
        _entries = [];
      }
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('journal_entries', json.encode(_entries.map((e) => e.toJson()).toList()));
  }

  Future<void> addEntry(JournalEntry entry) async {
    _entries.insert(0, entry);
    notifyListeners();
    await _persist();
  }

  Future<void> updateEntry(JournalEntry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index >= 0) {
      _entries[index] = entry;
      notifyListeners();
      await _persist();
    }
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
    await _persist();
  }
}
