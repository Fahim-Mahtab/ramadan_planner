import 'package:flutter/foundation.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/services/ai_service.dart';

class AIQuranPlanProvider with ChangeNotifier {
  String? _generatedPlan;
  bool _isLoading = false;
  String? _error;

  String? get generatedPlan => _generatedPlan;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> generatePlan({
    required int daysLeft,
    required int minutesPerDay,
    required String readingSpeed,
  }) async {
    _isLoading = true;
    _error = null;
    _generatedPlan = null;
    notifyListeners();

    try {
      final langCode = FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';
      final languageName = langCode == 'en' ? 'English' : 'Bengali (Bangla)';

      final systemPrompt = 
            "You are a helpful Islamic Assistant specializing in Quran reading plans. "
            "The user wants to finish reading the Quran (which has 604 pages / 30 Juz) before Ramadan ends. "
            "You MUST converse exclusively in $languageName. "
            "Generate a realistic, segmented reading schedule based on the user's inputs. "
            "For example, break it down across the 5 daily prayers (Fajr, Dhuhr, Asr, Maghrib, Isha). "
            "Format your response cleanly using Markdown lists and bold text.";

      final userText = langCode == 'en'
          ? "Days left in Ramadan: $daysLeft days. "
            "I can read for: $minutesPerDay minutes per day. "
            "My reading speed is: $readingSpeed. "
            "Please create a beautiful and realistic Quran reading routine for me."
          : "রমজানের বাকি আছে: $daysLeft দিন। "
            "আমি দিনে পড়তে পারব: $minutesPerDay মিনিট। "
            "আমার পড়ার গতি: $readingSpeed। "
            "দয়া করে আমাকে একটি সুন্দর এবং বাস্তবসম্মত কোরআন পড়ার রুটিন তৈরি করে দিন।";

      final messages = [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userText},
      ];

      final responseText = await AIService.getChatCompletion(
        messages: messages,
        model: "gpt-4o-mini",
      );

      _generatedPlan = responseText;
    } catch (e) {
      _error = "${AppLocale.format(AppLocale.aiZakatError)}: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearPlan() {
    _generatedPlan = null;
    _error = null;
    notifyListeners();
  }
}
