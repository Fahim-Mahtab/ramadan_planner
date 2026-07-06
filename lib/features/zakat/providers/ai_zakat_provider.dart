import 'package:flutter/foundation.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/services/ai_service.dart';
import '../../community/models/chat_message.dart';

class AIZakatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  void init() {
    if (_messages.isNotEmpty) return;
    
    _messages.add(
      ChatMessage(
        text: AppLocale.format(AppLocale.aiZakatInitialMsg),
        isUser: false,
        timestamp: DateTime.now(),
      )
    );
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

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

      final systemPrompt = 
          "You are a helpful Zakat Calculator Assistant. Your goal is to guide the user step-by-step to calculate their Zakat. "
          "You MUST converse exclusively in $languageName. "
          "Instead of asking for everything at once, ask one question at a time. "
          "Step 1: Ask about Gold (and its value or weight). "
          "Step 2: Ask about Silver. "
          "Step 3: Ask about Cash and Bank Savings. "
          "Step 4: Ask about Business inventory/assets. "
          "Step 5: Ask about debts or liabilities to be deducted. "
          "Keep a running total internally. At the end, if the net total reaches the Nisab (mention the current approximate Nisab value for Gold/Silver in BDT or their currency), calculate 2.5% as Zakat and tell them the final amount clearly.";

      final List<Map<String, String>> apiMessages = [
        {'role': 'system', 'content': systemPrompt},
      ];

      // Exclude welcome message from API chat history
      for (final m in _messages) {
        if (m == _messages.first && !m.isUser) continue;
        apiMessages.add({
          'role': m.isUser ? 'user' : 'assistant',
          'content': m.text,
        });
      }

      final responseText = await AIService.getChatCompletion(
        messages: apiMessages,
        model: "gpt-4o-mini",
      );

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
          text: "${AppLocale.format(AppLocale.aiZakatError)}: ${e.toString()}",
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
