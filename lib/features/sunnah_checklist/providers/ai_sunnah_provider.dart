import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/ai_sunnah_model.dart';

class AISunnahProvider with ChangeNotifier {
  List<AISunnahAct> _items = [];
  bool _isLoading = true;
  String? _error;

  List<AISunnahAct> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get completedCount => _items.where((item) => item.isCompleted).length;
  double get totalProgress => _items.isEmpty ? 0 : completedCount / _items.length;

  String get _currentDateKey => DateFormat('yyyy_MM_dd').format(DateTime.now());

  AISunnahProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = _currentDateKey;
      final savedData = prefs.getString('ai_sunnah_$dateKey');

      if (savedData != null) {
        final List<dynamic> decoded = json.decode(savedData);
        _items = decoded.map((e) => AISunnahAct.fromJson(e)).toList();
      } else {
        await _fetchFromAI();
      }
    } catch (e) {
      _error = 'Failed to load Sunnah checklist: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchFromAI() async {
    try {
      OpenAI.apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

      final systemPrompt = '''
You are an expert Islamic scholar. Generate exactly 5 unique, varied Sunnah acts of Prophet Muhammad (PBUH) for daily practice.
Respond STRICTLY with a JSON array. Each element must be a JSON object with these exact keys:
"id" (a unique string like "sunnah_1"),
"titleEn" (English title),
"titleBn" (Bengali title),
"evidenceEn" (Short English evidence/reference),
"evidenceBn" (Short Bengali evidence/reference).
Do not include markdown tags like ```json.
''';

      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-4o-mini",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(systemPrompt)],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text('Generate the 5 daily sunnahs.')],
          ),
        ],
        temperature: 0.7,
      );

      final responseText = chatCompletion.choices.first.message.content?.first.text?.trim() ?? '[]';
      String jsonStr = responseText;
      if (jsonStr.startsWith('```json')) {
        jsonStr = jsonStr.replaceAll('```json', '').replaceAll('```', '').trim();
      }

      final List<dynamic> decoded = json.decode(jsonStr);
      _items = decoded.map((e) => AISunnahAct.fromJson(e)).toList();
      
      await _saveItems();
    } catch (e) {
      _error = 'Failed to generate AI Sunnah checklist: $e';
    }
  }

  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_items.map((e) => e.toJson()).toList());
    await prefs.setString('ai_sunnah_$_currentDateKey', encoded);
  }

  Future<void> toggleItem(int index) async {
    if (index >= 0 && index < _items.length) {
      _items[index].toggle();
      notifyListeners();
      await _saveItems();
    }
  }
}
