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
  OpenAIService({http.Client? client, Future<void> Function(Duration)? wait})
      : _client = client ?? http.Client(),
        _wait = wait ?? Future.delayed,
        _apiKey = const String.fromEnvironment('OPENAI_API_KEY');

  final http.Client _client;
  final Future<void> Function(Duration) _wait;
  final String _apiKey;
  final String _endpoint = 'https://api.openai.com/v1/chat/completions';
  final Duration _timeout = const Duration(seconds: 30);

  /// Total number of API requests made.
  int requestCount = 0;

  /// Aggregate token usage returned by the API.
  int totalTokens = 0;

  /// Sends a chat request to the OpenAI API and returns the response content.
  Future<String> sendChatRequest(
      String message, List<ChatMessage> context) async {
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
          await _wait(delay);
          delay *= 2;
          retries++;
          continue;
        }

        throw Exception(
            'OpenAI request failed with status: ${response.statusCode}');
      } on TimeoutException {
        if (retries < 3) {
          await _wait(delay);
          delay *= 2;
          retries++;
          continue;
        }
        rethrow;
      }
    }
  }

  /// Streams a chat completion response from the OpenAI API.
  ///
  /// The returned stream emits content chunks as they arrive from the
  /// API. Errors and timeouts mirror the behaviour of [sendChatRequest].
  Stream<String> streamChatRequest(
      String message, List<ChatMessage> context) async* {
    final messages = [
      for (final m in context) {'role': m.role, 'content': m.content},
      {'role': 'user', 'content': message},
    ];

    final req = http.Request('POST', Uri.parse(_endpoint))
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      })
      ..body = jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': messages,
        'stream': true,
      });

    http.StreamedResponse resp;
    try {
      resp = await _client.send(req).timeout(_timeout);
    } on TimeoutException {
      throw TimeoutException('OpenAI request timed out');
    }

    if (resp.statusCode != 200) {
      throw Exception('OpenAI request failed with status: ${resp.statusCode}');
    }

    requestCount++;

    final stream =
        resp.stream.transform(utf8.decoder).transform(const LineSplitter());

    await for (var line in stream) {
      line = line.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('data:')) {
        line = line.substring(5).trim();
      }
      if (line == '[DONE]') break;
      final Map<String, dynamic> data = jsonDecode(line);
      final delta = data['choices'][0]['delta']['content'];
      if (delta is String && delta.isNotEmpty) {
        yield delta;
      }
    }
  }
}
