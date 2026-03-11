import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/checklist_item_model.dart';

/// Provider for managing Sunnah checklist
class ChecklistProvider with ChangeNotifier {
  List<ChecklistItemModel> _items = [];
  bool _isLoading = true;

  ChecklistProvider() {
    _initializeItems();
  }

  List<ChecklistItemModel> get items => _items;
  bool get isLoading => _isLoading;

  int get completedCount => _items.where((item) => item.isCompleted).length;

  String get _currentDateKey => DateFormat('yyyy_MM_dd').format(DateTime.now());

  Future<void> _initializeItems() async {
    final prefs = await SharedPreferences.getInstance();
    final dateKey = _currentDateKey;
    final savedData = prefs.getString('checklist_$dateKey');

    if (savedData != null) {
      try {
        final List<dynamic> decoded = json.decode(savedData);
        _items = decoded
            .map(
              (e) => ChecklistItemModel(
                title: e['title'] as String,
                isCompleted: e['isCompleted'] as bool,
              ),
            )
            .toList();
      } catch (e) {
        _items = _defaultItems();
      }
    } else {
      _items = _defaultItems();
    }

    _isLoading = false;
    notifyListeners();
  }

  List<ChecklistItemModel> _defaultItems() => [
    ChecklistItemModel(
      title: 'Give Sadaqah (Charity) today',
      isCompleted: false,
    ),
    ChecklistItemModel(
      title: 'Recite Surah Al-Mulk before bed',
      isCompleted: false,
    ),
    ChecklistItemModel(title: 'Make Dua for the Ummah', isCompleted: false),
  ];

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final dateKey = _currentDateKey;
    final encoded = json.encode(
      _items
          .map((e) => {'title': e.title, 'isCompleted': e.isCompleted})
          .toList(),
    );
    await prefs.setString('checklist_$dateKey', encoded);
  }

  Future<void> toggleItem(int index) async {
    if (index >= 0 && index < _items.length) {
      _items[index].toggle();
      notifyListeners();
      await _saveItems();
    }
  }

  Future<void> addItem(String title) async {
    _items.add(ChecklistItemModel(title: title));
    notifyListeners();
    await _saveItems();
  }

  Future<void> removeItem(int index) async {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
      await _saveItems();
    }
  }

  Future<void> resetAll() async {
    for (var item in _items) {
      item.isCompleted = false;
    }
    notifyListeners();
    await _saveItems();
  }
}
