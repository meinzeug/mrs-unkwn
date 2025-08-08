import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mrs_unkwn_app/features/tutoring/presentation/bloc/tutoring_bloc.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/services/ai_response_service.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/services/subject_classification_service.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/services/content_moderation_service.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/services/chat_history_service.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/prompts/socratic_prompts.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/models/chat_message.dart';
import 'package:mrs_unkwn_app/features/analytics/data/services/learning_analytics_service.dart';

class MockAIResponseService extends Mock implements AIResponseService {}

class MockSubjectClassificationService extends Mock
    implements SubjectClassificationService {}

class MockContentModerationService extends Mock
    implements ContentModerationService {}

class MockModerationLogService extends Mock implements ModerationLogService {}

class MockParentNotificationService extends Mock
    implements ParentNotificationService {}

class MockLearningAnalyticsService extends Mock
    implements LearningAnalyticsService {}

class MockChatHistoryService extends Mock implements ChatHistoryService {}

void main() {
  late MockAIResponseService ai;
  late MockSubjectClassificationService classifier;
  late MockContentModerationService moderator;
  late MockModerationLogService logService;
  late MockParentNotificationService notifier;
  late MockLearningAnalyticsService analytics;
  late MockChatHistoryService history;

  setUpAll(() {
    registerFallbackValue(<ChatMessage>[]);
    registerFallbackValue(TutoringSubject.math);
    registerFallbackValue(<ModerationCategory>[]);
  });

  setUp(() {
    ai = MockAIResponseService();
    classifier = MockSubjectClassificationService();
    moderator = MockContentModerationService();
    logService = MockModerationLogService();
    notifier = MockParentNotificationService();
    analytics = MockLearningAnalyticsService();
    history = MockChatHistoryService();
  });

  TutoringBloc buildBloc() => TutoringBloc(
        aiService: ai,
        classifier: classifier,
        moderator: moderator,
        logService: logService,
        notifier: notifier,
        analytics: analytics,
        history: history,
      );

  blocTest<TutoringBloc, TutoringState>(
    'emits MessageSent twice when message is clean',
    build: () {
      when(() => moderator.check(any()))
          .thenReturn(const ModerationResult(isClean: true));
      when(() => classifier.classify(any())).thenReturn(['math']);
      when(() => history.addMessage(any())).thenAnswer((_) async {});
      when(
        () => ai.generateResponse(
          history: any(named: 'history'),
          question: any(named: 'question'),
          subject: any(named: 'subject'),
          age: any(named: 'age'),
        ),
      ).thenAnswer((_) => Stream.value('hi'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const SendMessageRequested('Hi', age: 14)),
    expect: () => [
      isA<MessageSent>().having((s) => s.messages.length, 'len', 1),
      isA<MessageSent>().having((s) => s.messages.length, 'len', 2),
    ],
  );

  blocTest<TutoringBloc, TutoringState>(
    'emits TutoringError when message is flagged by moderation',
    build: () {
      when(() => moderator.check(any())).thenReturn(
        const ModerationResult(
          isClean: false,
          categories: [ModerationCategory.profanity],
        ),
      );
      when(() => logService.add(any(), any())).thenReturn(null);
      when(
        () => notifier.notify(
          message: any(named: 'message'),
          categories: any(named: 'categories'),
        ),
      ).thenAnswer((_) async {});
      return buildBloc();
    },
    act: (bloc) => bloc.add(const SendMessageRequested('bad', age: 14)),
    expect: () => [isA<TutoringError>()],
    verify: (_) {
      verify(() => logService.add(any(), any())).called(1);
      verify(
        () => notifier.notify(
          message: any(named: 'message'),
          categories: any(named: 'categories'),
        ),
      ).called(1);
    },
  );
}
