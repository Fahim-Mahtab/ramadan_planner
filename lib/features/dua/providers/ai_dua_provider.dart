import 'package:flutter/foundation.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../core/services/ai_service.dart';

class RecommendedDua {
  final String arabicText;
  final String transliteration;
  final String translation;
  final String explanation;

  RecommendedDua({
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.explanation,
  });
}

class AIDuaProvider with ChangeNotifier {
  RecommendedDua? _recommendedDua;
  bool _isLoading = false;
  String? _error;

  RecommendedDua? get recommendedDua => _recommendedDua;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDuaRecommendation(String emotion) async {
    if (emotion.trim().isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final langCode = FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';
      final languageName = langCode == 'en' ? 'English' : 'Bengali (Bangla)';

      final systemPrompt = 
            "You are an empathetic Islamic assistant. The user will state how they are feeling (their emotion or situation). "
            "You must recommend exactly ONE authentic Dua (from Quran or authentic Hadith) that perfectly suits their situation. "
            "IMPORTANT: Your response MUST be in $languageName. "
            "Output the response in the following exact strict format. Do not add any extra greeting or conversational text outside this format:\n\n"
            "ARABIC:\n<the arabic text of the dua>\n"
            "TRANSLITERATION:\n<the $languageName transliteration of the arabic text>\n"
            "TRANSLATION:\n<the $languageName translation of the dua>\n"
            "EXPLANATION:\n<a short, empathetic explanation in $languageName of why this dua will help them>";

      final messages = [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': "I am feeling: $emotion"},
      ];

      final responseText = await AIService.getChatCompletion(
        messages: messages,
        model: "gpt-4o-mini",
      );
      
      _parseResponse(responseText);
    } catch (e) {
      _error = "Error fetching dua: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _parseResponse(String response) {
    try {
      String arabic = "";
      String transliteration = "";
      String translation = "";
      String explanation = "";

      final parts = response.split(RegExp(r'(ARABIC:|TRANSLITERATION:|TRANSLATION:|EXPLANATION:)'));
      // parts[0] is usually empty before ARABIC:
      if (parts.length >= 5) {
        arabic = parts[1].trim();
        transliteration = parts[2].trim();
        translation = parts[3].trim();
        explanation = parts[4].trim();
      } else {
        // Fallback if formatting breaks
        explanation = response;
      }

      _recommendedDua = RecommendedDua(
        arabicText: arabic,
        transliteration: transliteration,
        translation: translation,
        explanation: explanation,
      );
    } catch (e) {
      _error = "Could not process the recommendation.";
    }
  }

  void clearRecommendation() {
    _recommendedDua = null;
    _error = null;
    notifyListeners();
  }
}
