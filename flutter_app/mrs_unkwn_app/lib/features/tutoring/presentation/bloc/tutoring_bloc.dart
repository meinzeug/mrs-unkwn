import 'dart:async';

import '../../../../core/bloc/base_bloc.dart';
import '../../../../core/bloc/base_event.dart';
import '../../../../core/bloc/base_state.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/learning_session.dart';
import '../../data/prompts/socratic_prompts.dart';
import '../../data/services/ai_response_service.dart';
import '../../data/services/subject_classification_service.dart';
import '../../data/services/content_moderation_service.dart';

/// Events
abstract class TutoringEvent extends BaseEvent {
  const TutoringEvent();
}

class SendMessageRequested extends TutoringEvent {
  const SendMessageRequested(this.message, {required this.age});

  final String message;
  final int age;
}

class LoadChatHistoryRequested extends TutoringEvent {
  const LoadChatHistoryRequested();
}

class StartLearningSessionRequested extends TutoringEvent {
  const StartLearningSessionRequested();
}

class EndLearningSessionRequested extends TutoringEvent {
  const EndLearningSessionRequested();
}

/// States
abstract class TutoringState extends BaseState {
  const TutoringState();
}

class TutoringInitial extends TutoringState {
  const TutoringInitial();
}

class TutoringLoading extends TutoringState {
  const TutoringLoading();
}

class MessagesLoaded extends TutoringState {
  const MessagesLoaded(this.messages);

  final List<ChatMessage> messages;
}

class MessageSent extends TutoringState {
  const MessageSent(this.messages);

  final List<ChatMessage> messages;
}

class TutoringError extends TutoringState {
  const TutoringError(this.message);

  final String message;
}

/// BLoC handling tutoring chat logic.
class TutoringBloc extends BaseBloc<TutoringEvent, TutoringState> {
  TutoringBloc({
    AIResponseService? aiService,
    SubjectClassificationService? classifier,
    ContentModerationService? moderator,
    ModerationLogService? logService,
    ParentNotificationService? notifier,
  })  : _aiService = aiService ?? AIResponseService(),
        _classifier = classifier ?? SubjectClassificationService(),
        _moderator = moderator ?? ContentModerationService(),
        _logService = logService ?? ModerationLogService(),
        _notifier = notifier ?? ParentNotificationService(),
        super(const TutoringInitial()) {
    on<SendMessageRequested>(_onSendMessageRequested);
    on<LoadChatHistoryRequested>(_onLoadChatHistoryRequested);
    on<StartLearningSessionRequested>(_onStartLearningSessionRequested);
    on<EndLearningSessionRequested>(_onEndLearningSessionRequested);
  }

  final AIResponseService _aiService;
  final SubjectClassificationService _classifier;
  final ContentModerationService _moderator;
  final ModerationLogService _logService;
  final ParentNotificationService _notifier;
  final List<ChatMessage> _history = [];
  LearningSession? _session;

  Future<void> _onLoadChatHistoryRequested(
    LoadChatHistoryRequested event,
    Emitter<TutoringState> emit,
  ) async {
    emit(const TutoringLoading());
    // TODO: Load from persistent storage when available.
    emit(MessagesLoaded(List.unmodifiable(_history)));
  }

  Future<void> _onStartLearningSessionRequested(
    StartLearningSessionRequested event,
    Emitter<TutoringState> emit,
  ) async {
    _session = LearningSession.start();
  }

  Future<void> _onEndLearningSessionRequested(
    EndLearningSessionRequested event,
    Emitter<TutoringState> emit,
  ) async {
    _session = _session?.end();
  }

  Future<void> _onSendMessageRequested(
    SendMessageRequested event,
    Emitter<TutoringState> emit,
  ) async {
    final moderation = _moderator.check(event.message);
    if (!moderation.isClean) {
      _logService.add(event.message, moderation.categories);
      await _notifier.notify(
        message: event.message,
        categories: moderation.categories,
      );
      emit(const TutoringError('Message contains inappropriate content.'));
      return;
    }

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: ChatRole.user,
      type: ChatMessageType.text,
      content: event.message,
      timestamp: DateTime.now(),
    );
    _history.add(userMessage);
    _session = _session?.incrementQuestion(
      topic: _classifier.classify(event.message).first,
    );
    emit(MessageSent(List.unmodifiable(_history)));

    try {
      final subjects = _classifier.classify(event.message);
      final subjectEnum = _mapSubject(subjects.first);
      final buffer = StringBuffer();
      await for (final chunk in _aiService.generateResponse(
        history: _history,
        question: event.message,
        subject: subjectEnum,
        age: event.age,
      )) {
        buffer.write('$chunk ');
      }

      final responseText = buffer.toString().trim();
      final aiModeration = _moderator.check(responseText);
      if (!aiModeration.isClean) {
        _logService.add(responseText, aiModeration.categories);
        await _notifier.notify(
          message: 'AI response',
          categories: aiModeration.categories,
        );
        final aiMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          role: ChatRole.assistant,
          type: ChatMessageType.text,
          content: '[Content removed]',
          timestamp: DateTime.now(),
        );
        _history.add(aiMessage);
        emit(MessageSent(List.unmodifiable(_history)));
        return;
      }

      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: ChatRole.assistant,
        type: ChatMessageType.text,
        content: responseText,
        timestamp: DateTime.now(),
      );
      _history.add(aiMessage);
      _session = _session?.incrementAiInteractions();
      emit(MessageSent(List.unmodifiable(_history)));
    } catch (e) {
      emit(TutoringError(e.toString()));
    }
  }

  TutoringSubject _mapSubject(String subject) {
    switch (subject) {
      case 'science':
        return TutoringSubject.science;
      case 'literature':
        return TutoringSubject.literature;
      case 'history':
        return TutoringSubject.history;
      case 'math':
      default:
        return TutoringSubject.math;
    }
  }
}

