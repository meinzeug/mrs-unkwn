import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

enum ChatRole { user, assistant, system }

enum ChatMessageType { text, image, file }

@JsonSerializable()
class ChatMessage {
  final String id;
  final ChatRole role;
  final ChatMessageType type;
  final String content;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final String? attachmentUrl;
  final String? threadId;
  final String? parentId;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.type,
    required this.content,
    required this.timestamp,
    this.metadata,
    this.attachmentUrl,
    this.threadId,
    this.parentId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

