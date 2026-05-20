import 'package:flutter/foundation.dart';
import '../models/fitra_item_model.dart';

class ZakatProvider with ChangeNotifier {
  int _familyCount = 1;
  FitraItemModel _selectedItem = defaultFitraItems.first;

  int get familyCount => _familyCount;
  FitraItemModel get selectedItem => _selectedItem;

  double get totalFitra => _familyCount * _selectedItem.pricePerPerson;

  void setFamilyCount(int count) {
    if (count > 0 && count < 100) {
      _familyCount = count;
      notifyListeners();
    }
  }

  void selectItem(FitraItemModel item) {
    _selectedItem = item;
    notifyListeners();
  }
}
