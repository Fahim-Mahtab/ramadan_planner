import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dua_model.dart';

class DuaProvider with ChangeNotifier {
  Set<String> _favorites = {};
  final Map<String, int> _tasbihCounts = {};
  bool _isLoading = true;

  DuaProvider() {
    _initialize();
  }

  bool get isLoading => _isLoading;
  Set<String> get favorites => _favorites;

  String get _todayKey => DateFormat('yyyy_MM_dd').format(DateTime.now());

  DuaModel get duaOfTheDay {
    final index = DateTime.now().day % allDuas.length;
    return allDuas[index];
  }

  bool isFavorite(String duaId) => _favorites.contains(duaId);

  int getTasbihCount(String duaId) => _tasbihCounts[duaId] ?? 0;

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();

    final favJson = prefs.getString('dua_favorites');
    if (favJson != null) {
      try {
        final List<dynamic> decoded = json.decode(favJson);
        _favorites = decoded.cast<String>().toSet();
      } catch (_) {
        _favorites = {};
      }
    }

    for (final dua in allDuas) {
      if (dua.tasbihTarget > 0) {
        final count = prefs.getInt('tasbih_${dua.id}_$_todayKey') ?? 0;
        _tasbihCounts[dua.id] = count;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(String duaId) async {
    if (_favorites.contains(duaId)) {
      _favorites.remove(duaId);
    } else {
      _favorites.add(duaId);
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dua_favorites', json.encode(_favorites.toList()));
  }

  Future<void> incrementTasbih(String duaId) async {
    final current = _tasbihCounts[duaId] ?? 0;
    _tasbihCounts[duaId] = current + 1;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbih_${duaId}_$_todayKey', current + 1);
  }

  Future<void> resetTasbih(String duaId) async {
    _tasbihCounts[duaId] = 0;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbih_${duaId}_$_todayKey', 0);
  }
}
