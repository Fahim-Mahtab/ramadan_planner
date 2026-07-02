import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/hadith_collection.dart';
import '../models/hadith_model.dart';

class HadithProvider with ChangeNotifier {
  Set<int> _bookmarked = {};
  bool _isInitialized = false;

  Set<int> get bookmarked => _bookmarked;
  bool get isInitialized => _isInitialized;

  HadithModel get hadithOfTheDay {
    final dayIndex = DateTime.now().day % allHadith.length;
    return allHadith[dayIndex];
  }

  List<HadithModel> get all => allHadith;

  Future<void> init() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('hadith_bookmarks');
    if (data != null) {
      final list = json.decode(data) as List;
      _bookmarked = list.cast<int>().toSet();
    }
    _isInitialized = true;
    notifyListeners();
  }

  bool isBookmarked(int number) => _bookmarked.contains(number);

  Future<void> toggleBookmark(int number) async {
    if (_bookmarked.contains(number)) {
      _bookmarked.remove(number);
    } else {
      _bookmarked.add(number);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('hadith_bookmarks', json.encode(_bookmarked.toList()));
  }
}
