import 'package:flutter/foundation.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../core/l10n/app_locale.dart';

class AIQuranPlanProvider with ChangeNotifier {
  String? _generatedPlan;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  String? get generatedPlan => _generatedPlan;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _init() {
    if (_isInitialized) return;
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      OpenAI.apiKey = apiKey;
      _isInitialized = true;
    }
  }

  Future<void> generatePlan({
    required int daysLeft,
    required int minutesPerDay,
    required String readingSpeed,
  }) async {
    _init();
    if (!_isInitialized) {
      _error = "OpenAI API Key is missing.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _generatedPlan = null;
    notifyListeners();

    try {
      final langCode = FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';
      final languageName = langCode == 'en' ? 'English' : 'Bengali (Bangla)';

      final systemMessage = OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            "You are a helpful Islamic Assistant specializing in Quran reading plans. "
            "The user wants to finish reading the Quran (which has 604 pages / 30 Juz) before Ramadan ends. "
            "You MUST converse exclusively in $languageName. "
            "Generate a realistic, segmented reading schedule based on the user's inputs. "
            "For example, break it down across the 5 daily prayers (Fajr, Dhuhr, Asr, Maghrib, Isha). "
            "Format your response cleanly using Markdown lists and bold text."
          )
        ],
      );

      final userText = langCode == 'en'
          ? "Days left in Ramadan: $daysLeft days. "
            "I can read for: $minutesPerDay minutes per day. "
            "My reading speed is: $readingSpeed. "
            "Please create a beautiful and realistic Quran reading routine for me."
          : "রমজানের বাকি আছে: $daysLeft দিন। "
            "আমি দিনে পড়তে পারব: $minutesPerDay মিনিট। "
            "আমার পড়ার গতি: $readingSpeed। "
            "দয়া করে আমাকে একটি সুন্দর এবং বাস্তবসম্মত কোরআন পড়ার রুটিন তৈরি করে দিন।";

      final userMessage = OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(userText)
        ],
      );

      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-4o-mini",
        messages: [systemMessage, userMessage],
      );

      _generatedPlan = chatCompletion.choices.first.message.content?.first.text ?? AppLocale.format(AppLocale.aiZakatError);
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
