import 'package:flutter_test/flutter_test.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/models/chat_message.dart';

void main() {
  group('ChatMessage serialization', () {
    test('toJson and fromJson preserve all fields', () {
      final original = ChatMessage(
        id: '1',
        role: ChatRole.user,
        type: ChatMessageType.text,
        content: 'Hello',
        timestamp: DateTime.parse('2025-10-04T12:00:00Z'),
        metadata: {'foo': 'bar'},
        attachmentUrl: 'https://example.com/file',
        threadId: 'thread-1',
        parentId: 'parent-1',
      );

      final json = original.toJson();
      final restored = ChatMessage.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.role, original.role);
      expect(restored.type, original.type);
      expect(restored.content, original.content);
      expect(restored.timestamp, original.timestamp);
      expect(restored.metadata, original.metadata);
      expect(restored.attachmentUrl, original.attachmentUrl);
      expect(restored.threadId, original.threadId);
      expect(restored.parentId, original.parentId);
    });
  });
}
