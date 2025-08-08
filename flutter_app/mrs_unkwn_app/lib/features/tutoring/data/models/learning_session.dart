import 'package:json_annotation/json_annotation.dart';

part 'learning_session.g.dart';

@JsonSerializable()
class LearningSession {
  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  @JsonKey(defaultValue: 0)
  final int questionCount;
  @JsonKey(defaultValue: [])
  final List<String> topics;
  @JsonKey(defaultValue: 0)
  final int aiInteractions;
  @JsonKey(defaultValue: false)
  final bool isSynced;
  @JsonKey(defaultValue: false)
  final bool resumed;

  const LearningSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.questionCount = 0,
    this.topics = const [],
    this.aiInteractions = 0,
    this.isSynced = false,
    this.resumed = false,
  });

  factory LearningSession.start() => LearningSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        startedAt: DateTime.now(),
      );

  LearningSession end() => copyWith(endedAt: DateTime.now());

  Duration get duration => (endedAt ?? DateTime.now()).difference(startedAt);

  LearningSession incrementQuestion({String? topic}) {
    final updatedTopics = List<String>.from(topics);
    if (topic != null && topic.isNotEmpty && !updatedTopics.contains(topic)) {
      updatedTopics.add(topic);
    }
    return copyWith(
      questionCount: questionCount + 1,
      topics: updatedTopics,
    );
  }

  LearningSession incrementAiInteractions() =>
      copyWith(aiInteractions: aiInteractions + 1);

  LearningSession markSynced() => copyWith(isSynced: true);

  LearningSession copyWith({
    String? id,
    DateTime? startedAt,
    DateTime? endedAt,
    int? questionCount,
    List<String>? topics,
    int? aiInteractions,
    bool? isSynced,
    bool? resumed,
  }) =>
      LearningSession(
        id: id ?? this.id,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt ?? this.endedAt,
        questionCount: questionCount ?? this.questionCount,
        topics: topics ?? this.topics,
        aiInteractions: aiInteractions ?? this.aiInteractions,
        isSynced: isSynced ?? this.isSynced,
        resumed: resumed ?? this.resumed,
      );

  factory LearningSession.fromJson(Map<String, dynamic> json) =>
      _$LearningSessionFromJson(json);

  Map<String, dynamic> toJson() => _$LearningSessionToJson(this);
}

