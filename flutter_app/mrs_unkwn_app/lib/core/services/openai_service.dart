import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Represents a chat message in the conversation context.
class ChatMessage {
  final String role;
  final String content;

  ChatMessage({required this.role, required this.content});
}

/// Service for interacting with the OpenAI Chat Completion API.
class OpenAIService {
  OpenAIService({http.Client? client})
      : _client = client ?? http.Client(),
        _apiKey = const String.fromEnvironment('OPENAI_API_KEY');

  final http.Client _client;
  final String _apiKey;
  final String _endpoint = 'https://api.openai.com/v1/chat/completions';
  final Duration _timeout = const Duration(seconds: 30);

  /// Total number of API requests made.
  int requestCount = 0;

  /// Aggregate token usage returned by the API.
  int totalTokens = 0;

  /// Sends a chat request to the OpenAI API and returns the response content.
  Future<String> sendChatRequest(String message, List<ChatMessage> context) async {
    final messages = [
      for (final m in context) {'role': m.role, 'content': m.content},
      {'role': 'user', 'content': message},
    ];

    var retries = 0;
    var delay = const Duration(seconds: 1);

    while (true) {
      try {
        final response = await _client
            .post(
              Uri.parse(_endpoint),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $_apiKey',
              },
              body: jsonEncode({
                'model': 'gpt-3.5-turbo',
                'messages': messages,
              }),
            )
            .timeout(_timeout);

        if (response.statusCode == 200) {
          requestCount++;
          final Map<String, dynamic> data = jsonDecode(response.body);
          final usage = data['usage'] as Map<String, dynamic>?;
          if (usage != null) {
            totalTokens += usage['total_tokens'] as int? ?? 0;
          }
          return data['choices'][0]['message']['content'] as String;
        }

        if (response.statusCode == 429 && retries < 3) {
          await Future.delayed(delay);
          delay *= 2;
          retries++;
          continue;
        }

        throw Exception('OpenAI request failed with status: ${response.statusCode}');
      } on TimeoutException {
        if (retries < 3) {
          await Future.delayed(delay);
          delay *= 2;
          retries++;
          continue;
        }
        rethrow;
      }
    }
  }
}

