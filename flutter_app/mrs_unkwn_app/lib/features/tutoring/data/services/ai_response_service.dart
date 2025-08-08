import 'dart:async';

import '../../../../core/services/openai_service.dart' as oai;
import '../models/chat_message.dart';
import '../prompts/socratic_prompts.dart';

/// Service responsible for generating AI tutoring responses.
class AIResponseService {
  AIResponseService({oai.OpenAIService? openAI, Duration? streamDelay})
      : _openAI = openAI ?? oai.OpenAIService(),
        _delay = streamDelay ?? const Duration(milliseconds: 50);

  final oai.OpenAIService _openAI;
  final Duration _delay;
  final Map<String, String> _cache = {};

  static const Set<String> _bannedKeywords = {
    'violence',
    'suicide',
    'kill',
    'hate',
  };

  /// Generates a response stream for the given [question].
  ///
  /// [history] holds previous chat messages.
  /// [subject] and [age] build the system prompt.
  Stream<String> generateResponse({
    required List<ChatMessage> history,
    required String question,
    required TutoringSubject subject,
    required int age,
  }) async* {
    final cacheKey = '${subject.name}::$question';
    if (_cache.containsKey(cacheKey)) {
      yield _cache[cacheKey]!;
      return;
    }

    final context = [
      oai.ChatMessage(
        role: 'system',
        content: SocraticPrompts.systemPrompt(subject, age: age),
      ),
      ...history.map(
        (m) => oai.ChatMessage(role: _mapRole(m.role), content: m.content),
      ),
    ];

    String response;
    try {
      response = await _openAI.sendChatRequest(question, context);
    } catch (_) {
      yield 'Oops, something went wrong. Please try again.';
      return;
    }

    if (_containsBannedContent(response)) {
      yield 'I\'m sorry, but I can\'t help with that.';
      return;
    }

    _cache[cacheKey] = response;

    final parts = response.split(RegExp(r'\s+'));
    for (final part in parts) {
      yield part;
      await Future.delayed(_delay);
    }
  }

  bool _containsBannedContent(String text) {
    final lower = text.toLowerCase();
    return _bannedKeywords.any(lower.contains);
  }

  String _mapRole(ChatRole role) {
    switch (role) {
      case ChatRole.user:
        return 'user';
      case ChatRole.assistant:
        return 'assistant';
      case ChatRole.system:
        return 'system';
    }
  }
}

