import 'package:flutter/foundation.dart';
import '../models/checklist_item_model.dart';

/// Provider for managing Sunnah checklist
class ChecklistProvider with ChangeNotifier {
  List<ChecklistItemModel> _items = [];

  ChecklistProvider() {
    _initializeItems();
  }

  List<ChecklistItemModel> get items => _items;

  int get completedCount => _items.where((item) => item.isCompleted).length;

  void _initializeItems() {
    _items = [
      ChecklistItemModel(
        title: 'Give Sadaqah (Charity) today',
        isCompleted: true,
      ),
      ChecklistItemModel(
        title: 'Recite Surah Al-Mulk before bed',
        isCompleted: false,
      ),
      ChecklistItemModel(title: 'Make Dua for the Ummah', isCompleted: false),
    ];
  }

  void toggleItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].toggle();
      notifyListeners();
    }
  }

  void addItem(String title) {
    _items.add(ChecklistItemModel(title: title));
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void resetAll() {
    for (var item in _items) {
      item.isCompleted = false;
    }
    notifyListeners();
  }
}
