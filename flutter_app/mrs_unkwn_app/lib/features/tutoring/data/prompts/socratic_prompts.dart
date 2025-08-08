import '../models/chat_message.dart';

/// Subjects supported by the tutoring module.
enum TutoringSubject { math, science, literature, history }

/// Generates subject specific prompts that enforce the Socratic method.
class SocraticPrompts {
  static const Map<TutoringSubject, String> _systemPrompts = {
    TutoringSubject.math:
        'You are a Socratic math tutor for a {age}-year-old student. Ask short guiding questions that help the learner derive the solution step by step without giving the answer.',
    TutoringSubject.science:
        'You are a Socratic science tutor for a {age}-year-old student. Encourage curiosity by asking questions that lead to scientific reasoning and experimentation rather than stating facts.',
    TutoringSubject.literature:
        'You are a Socratic literature tutor for a {age}-year-old student. Explore themes, characters and the author\'s intent through probing questions instead of direct explanations.',
    TutoringSubject.history:
        'You are a Socratic history tutor for a {age}-year-old student. Guide the learner with questions that connect causes and consequences without recounting events outright.'
  };

  /// Returns the system prompt for the given [subject] and [age].
  static String systemPrompt(TutoringSubject subject, {required int age}) {
    return _systemPrompts[subject]!.replaceAll('{age}', age.toString());
  }

  /// Builds a full prompt including previous [history] and the current [question].
  ///
  /// [maxContextTokens] limits how many tokens from the conversation history are
  /// kept to stay within model limits.
  static String buildPrompt({
    required TutoringSubject subject,
    required int age,
    required List<ChatMessage> history,
    required String question,
    int maxContextTokens = 800,
  }) {
    final buffer = StringBuffer(systemPrompt(subject, age: age));
    final trimmed = _trimHistory(history, maxContextTokens);
    for (final msg in trimmed) {
      final speaker = msg.role == ChatRole.user ? 'Student' : 'Tutor';
      buffer.writeln('$speaker: ${msg.content}');
    }
    buffer.writeln('Student: $question');
    buffer.writeln('Tutor:');
    return buffer.toString();
  }

  /// Trims conversation [history] to respect [maxTokens] using a simple word
  /// count as token approximation.
  static List<ChatMessage> _trimHistory(
      List<ChatMessage> history, int maxTokens) {
    final List<ChatMessage> result = [];
    int tokenCount = 0;
    for (final msg in history.reversed) {
      final tokens = _countTokens(msg.content);
      if (tokenCount + tokens > maxTokens) break;
      result.add(msg);
      tokenCount += tokens;
    }
    return result.reversed.toList();
  }

  /// Naively counts tokens by splitting on whitespace.
  static int _countTokens(String text) {
    return text.trim().isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
  }
}
