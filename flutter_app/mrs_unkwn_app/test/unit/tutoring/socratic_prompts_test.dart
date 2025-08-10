import 'package:flutter_test/flutter_test.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/models/chat_message.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/prompts/socratic_prompts.dart';

void main() {
  group('SocraticPrompts', () {
    test('systemPrompt injects age', () {
      final prompt = SocraticPrompts.systemPrompt(
        TutoringSubject.math,
        age: 14,
      );
      expect(prompt, contains('14-year-old'));
    });

    test('buildPrompt trims history and formats conversation', () {
      final history = [
        ChatMessage(
          id: '1',
          role: ChatRole.user,
          type: ChatMessageType.text,
          content: 'Old message',
          timestamp: DateTime.parse('2025-10-05T12:00:00Z'),
        ),
        ChatMessage(
          id: '2',
          role: ChatRole.assistant,
          type: ChatMessageType.text,
          content: 'Response',
          timestamp: DateTime.parse('2025-10-05T12:01:00Z'),
        ),
        ChatMessage(
          id: '3',
          role: ChatRole.user,
          type: ChatMessageType.text,
          content: 'Recent question',
          timestamp: DateTime.parse('2025-10-05T12:02:00Z'),
        ),
      ];

      final result = SocraticPrompts.buildPrompt(
        subject: TutoringSubject.math,
        age: 14,
        history: history,
        question: 'New question',
        maxContextTokens: 4,
      );

      expect(result, isNot(contains('Old message')));
      expect(result, contains('Tutor: Response'));
      expect(result, contains('Student: Recent question'));
      expect(result, contains('Student: New question'));
      expect(result.trimRight(), endsWith('Tutor:'));
    });
  });
}
