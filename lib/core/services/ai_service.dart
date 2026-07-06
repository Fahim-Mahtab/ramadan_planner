import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

class AIService {
  /// Sends a chat completion request to the VPS OpenAI proxy endpoint.
  /// Automatically appends the user's Supabase session access token for authentication.
  static Future<String> getChatCompletion({
    required List<Map<String, String>> messages,
    String model = 'gpt-4o-mini',
    double temperature = 0.7,
  }) async {
    final session = Supabase.instance.client.auth.currentSession;
    final token = session?.accessToken;

    if (token == null) {
      throw Exception("User session expired or unauthenticated. Please sign in to use AI features.");
    }

    final response = await http.post(
      Uri.parse('${AppConfig.vpsUrl}/api/openai/chat'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'temperature': temperature,
      }),
    );

    if (response.statusCode != 200) {
      try {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to connect to AI proxy.');
      } catch (_) {
        throw Exception('Server error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    }

    final data = jsonDecode(response.body);
    final choices = data['choices'] as List?;
    if (choices == null || choices.isEmpty) {
      throw Exception('OpenAI returned an empty response.');
    }
    
    return choices[0]['message']['content'] as String? ?? '';
  }
}
