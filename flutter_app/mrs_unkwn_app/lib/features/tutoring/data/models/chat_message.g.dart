// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['id'] as String,
      role: $enumDecode(_$ChatRoleEnumMap, json['role']),
      type: $enumDecode(_$ChatMessageTypeEnumMap, json['type']),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      attachmentUrl: json['attachmentUrl'] as String?,
      threadId: json['threadId'] as String?,
      parentId: json['parentId'] as String?,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) => <String, dynamic>{
      'id': instance.id,
      'role': _$ChatRoleEnumMap[instance.role]!,
      'type': _$ChatMessageTypeEnumMap[instance.type]!,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
      'attachmentUrl': instance.attachmentUrl,
      'threadId': instance.threadId,
      'parentId': instance.parentId,
    };

const Map<ChatRole, String> _$ChatRoleEnumMap = {
  ChatRole.user: 'user',
  ChatRole.assistant: 'assistant',
  ChatRole.system: 'system',
};

const Map<ChatMessageType, String> _$ChatMessageTypeEnumMap = {
  ChatMessageType.text: 'text',
  ChatMessageType.image: 'image',
  ChatMessageType.file: 'file',
};
