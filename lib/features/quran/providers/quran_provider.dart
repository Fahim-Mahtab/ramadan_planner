import 'package:flutter/foundation.dart';
import '../models/quran_progress_model.dart';

/// Provider for managing Quran reading progress
class QuranProvider with ChangeNotifier {
  QuranProgressModel _progress = QuranProgressModel(
    currentJuz: 10,
    currentPage: 194,
    targetJuz: 30,
  );

  QuranProgressModel get progress => _progress;

  double get percentage => _progress.percentage;

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
}
