// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_session.dart';

LearningSession _$LearningSessionFromJson(Map<String, dynamic> json) =>
    LearningSession(
      id: json['id'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      questionCount: json['questionCount'] as int? ?? 0,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      aiInteractions: json['aiInteractions'] as int? ?? 0,
      isSynced: json['isSynced'] as bool? ?? false,
      resumed: json['resumed'] as bool? ?? false,
    );

Map<String, dynamic> _$LearningSessionToJson(LearningSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt?.toIso8601String(),
      'questionCount': instance.questionCount,
      'topics': instance.topics,
      'aiInteractions': instance.aiInteractions,
      'isSynced': instance.isSynced,
      'resumed': instance.resumed,
    };

