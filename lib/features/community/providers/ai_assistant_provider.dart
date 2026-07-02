import 'package:flutter/foundation.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../models/chat_message.dart';

class AIAssistantProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  void init() {
    if (_isInitialized) return;
    
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      OpenAI.apiKey = apiKey;
      _isInitialized = true;
      
      final langCode = FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';
      final welcomeText = langCode == 'en' 
          ? "Assalamu Alaikum! I am your AI Islamic Assistant. How can I help you today with your Ramadan Planner, fasting, or any other Islamic topics?\n\n(Note: I am an AI, not a mufti or scholar. Please consult a qualified scholar for complex religious rulings.)"
          : "আসসালামু আলাইকুম! আমি আপনার এআই ইসলামিক অ্যাসিস্ট্যান্ট। আজ আপনার রমজান প্ল্যানার, রোজা বা অন্য কোনো ইসলামিক বিষয়ে আমি কীভাবে সাহায্য করতে পারি?\n\n(দ্রষ্টব্য: আমি একজন এআই, কোনো মুফতি বা আলেম নই। জটিল ধর্মীয় মাসআলার জন্য একজন বিজ্ঞ আলেমের সাথে পরামর্শ করুন।)";

      _messages.add(
        ChatMessage(
          text: welcomeText,
          isUser: false,
          timestamp: DateTime.now(),
        )
      );
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || !_isInitialized) return;

    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      final langCode = FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';
      final languageName = langCode == 'en' ? 'English' : 'Bengali (Bangla)';

      final systemMessage = OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            "You are a helpful, respectful, and knowledgeable AI Islamic assistant for a Ramadan Planner app. "
            "You answer questions related to Islam, Ramadan, fasting rules, Zakat, and Sunnah. "
            "Always be polite and base your answers on mainstream Sunni Islamic teachings (Quran and authentic Sunnah). "
            "CRITICAL RULE: You MUST always respond exclusively in $languageName. Ensure the grammar is natural and respectful. "
            "CRITICAL RULE 2: You are an AI, NOT a mufti or scholar. If asked for a fatwa on a complex personal issue, state you are an AI and advise consulting a local scholar."
          )
        ],
      );

      final historyMessages = _messages.map((m) {
        return OpenAIChatCompletionChoiceMessageModel(
          role: m.isUser ? OpenAIChatMessageRole.user : OpenAIChatMessageRole.assistant,
          content: [
             OpenAIChatCompletionChoiceMessageContentItemModel.text(m.text)
          ],
        );
      }).toList();

      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-4o-mini",
        messages: [systemMessage, ...historyMessages],
      );

      final responseText = chatCompletion.choices.first.message.content?.first.text ?? "Sorry, I couldn't process that.";

      _messages.add(
        ChatMessage(
          text: responseText,
          isUser: false,
          timestamp: DateTime.now(),
        )
      );
    } catch (e) {
      _messages.add(
        ChatMessage(
          text: "Error connecting to AI Assistant: ${e.toString()}",
          isUser: false,
          timestamp: DateTime.now(),
        )
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
