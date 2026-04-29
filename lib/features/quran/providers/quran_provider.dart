import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/quran_progress_model.dart';
import '../models/surah_info_model.dart';
import '../models/surah_detail_model.dart';

class QuranProvider with ChangeNotifier {
  QuranProgressModel _progress = QuranProgressModel(
    currentJuz: 10,
    currentPage: 194,
    targetJuz: 30,
  );

  QuranProgressModel get progress => _progress;
  double get percentage => _progress.percentage;

  // New API Data
  List<SurahInfoModel> _surahs = [];
  bool _isLoadingSurahs = false;
  String? _error;

  List<SurahInfoModel> get surahs => _surahs;
  bool get isLoadingSurahs => _isLoadingSurahs;
  String? get error => _error;

  // Cache for detailed surahs
  final Map<int, SurahDetailModel> _surahDetailsCache = {};

  void updateProgress({required int juz, required int page}) {
    if (juz >= 1 && juz <= 30 && page >= 1 && page <= 604) {
      _progress = _progress.copyWith(currentJuz: juz, currentPage: page);
      notifyListeners();
    }
  }

  void resetProgress() {
    _progress = QuranProgressModel(
      currentJuz: 1,
      currentPage: 1,
      targetJuz: 30,
    );
    notifyListeners();
  }

  Future<void> loadSurahs() async {
    if (_surahs.isNotEmpty) return;

    _isLoadingSurahs = true;
    _error = null;
    notifyListeners();

    try {
      final url = Uri.parse('https://quranapi.pages.dev/api/surah.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Response is a JSON array, but since it's an API returning large JSON, we decode it.
        // It's possible the JSON contains unicode perfectly.
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

        _surahs = data.asMap().entries.map((entry) {
          int index = entry.key;
          return SurahInfoModel.fromJson(entry.value, index + 1);
        }).toList();
      } else {
        _error = 'Failed to load Surahs: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading Surahs: $e';
    } finally {
      _isLoadingSurahs = false;
      notifyListeners();
    }
  }

  Future<SurahDetailModel?> loadSurahDetail(int surahNo) async {
    if (_surahDetailsCache.containsKey(surahNo)) {
      return _surahDetailsCache[surahNo];
    }

    try {
      final url = Uri.parse('https://quranapi.pages.dev/api/$surahNo.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(
          utf8.decode(response.bodyBytes),
        );
        final surahDetail = SurahDetailModel.fromJson(data, surahNo);
        _surahDetailsCache[surahNo] = surahDetail;
        return surahDetail;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading Surah Detail: $e');
      }
    }
    return null;
  }
}
