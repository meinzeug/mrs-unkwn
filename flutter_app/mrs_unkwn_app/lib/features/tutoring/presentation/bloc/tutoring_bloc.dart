import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/bloc/base_bloc.dart';
import '../../../../core/bloc/base_event.dart';
import '../../../../core/bloc/base_state.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/learning_session.dart';
import '../../data/prompts/socratic_prompts.dart';
import '../../data/services/ai_response_service.dart';
import '../../data/services/subject_classification_service.dart';
import '../../data/services/content_moderation_service.dart';
import '../../../analytics/data/services/learning_analytics_service.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/services/chat_history_service.dart';

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

class SearchChatHistoryRequested extends TutoringEvent {
  const SearchChatHistoryRequested({this.keyword, this.from, this.to});

  final String? keyword;
  final DateTime? from;
  final DateTime? to;
}

class ExportChatRequested extends TutoringEvent {
  const ExportChatRequested(this.path);

  final String path;
}

class BackupChatRequested extends TutoringEvent {
  const BackupChatRequested();
}

class RestoreChatRequested extends TutoringEvent {
  const RestoreChatRequested(this.json);

  final String json;
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

class ChatExported extends TutoringState {
  const ChatExported(this.path);

  final String path;
}

class ChatBackupCreated extends TutoringState {
  const ChatBackupCreated(this.data);

  final String data;
}

class ChatRestored extends TutoringState {
  const ChatRestored(this.messages);

  final List<ChatMessage> messages;
}

/// BLoC handling tutoring chat logic.
class TutoringBloc extends BaseBloc<TutoringEvent, TutoringState> {
  TutoringBloc({
    AIResponseService? aiService,
    SubjectClassificationService? classifier,
    ContentModerationService? moderator,
    ModerationLogService? logService,
    ParentNotificationService? notifier,
    LearningAnalyticsService? analytics,
    ChatHistoryService? history,
  })  : _aiService = aiService ?? AIResponseService(),
       _classifier = classifier ?? SubjectClassificationService(),
       _moderator = moderator ?? ContentModerationService(),
       _logService = logService ?? ModerationLogService(),
       _notifier = notifier ?? ParentNotificationService(),
       _analytics = analytics ?? sl<LearningAnalyticsService>(),
       _historyService = history ?? sl<ChatHistoryService>(),
        super(const TutoringInitial()) {
    on<SendMessageRequested>(_onSendMessageRequested);
    on<LoadChatHistoryRequested>(_onLoadChatHistoryRequested);
    on<StartLearningSessionRequested>(_onStartLearningSessionRequested);
    on<EndLearningSessionRequested>(_onEndLearningSessionRequested);
    on<SearchChatHistoryRequested>(_onSearchChatHistoryRequested);
    on<ExportChatRequested>(_onExportChatRequested);
    on<BackupChatRequested>(_onBackupChatRequested);
    on<RestoreChatRequested>(_onRestoreChatRequested);
  }

  final AIResponseService _aiService;
  final SubjectClassificationService _classifier;
  final ContentModerationService _moderator;
  final ModerationLogService _logService;
  final ParentNotificationService _notifier;
  final LearningAnalyticsService _analytics;
  final ChatHistoryService _historyService;
  final List<ChatMessage> _history = [];
  LearningSession? _session;

  Future<void> _onLoadChatHistoryRequested(
    LoadChatHistoryRequested event,
    Emitter<TutoringState> emit,
  ) async {
    emit(const TutoringLoading());
    final messages = await _historyService.getMessages();
    _history
      ..clear()
      ..addAll(messages);
    emit(MessagesLoaded(List.unmodifiable(_history)));
  }

  Future<void> _onSearchChatHistoryRequested(
    SearchChatHistoryRequested event,
    Emitter<TutoringState> emit,
  ) async {
    emit(const TutoringLoading());
    final results = await _historyService.search(
      keyword: event.keyword,
      from: event.from,
      to: event.to,
    );
    emit(MessagesLoaded(List.unmodifiable(results)));
  }

  Future<void> _onExportChatRequested(
    ExportChatRequested event,
    Emitter<TutoringState> emit,
  ) async {
    emit(const TutoringLoading());
    await _historyService.exportToFile(event.path);
    emit(ChatExported(event.path));
  }

  Future<void> _onBackupChatRequested(
    BackupChatRequested event,
    Emitter<TutoringState> emit,
  ) async {
    emit(const TutoringLoading());
    final data = await _historyService.backup();
    emit(ChatBackupCreated(data));
  }

  Future<void> _onRestoreChatRequested(
    RestoreChatRequested event,
    Emitter<TutoringState> emit,
  ) async {
    emit(const TutoringLoading());
    await _historyService.restore(event.json);
    final messages = await _historyService.getMessages();
    _history
      ..clear()
      ..addAll(messages);
    emit(ChatRestored(List.unmodifiable(_history)));
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
    if (_session != null) {
      _analytics.trackSession(_session!);
    }
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
    await _historyService.addMessage(userMessage);
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
      await _historyService.addMessage(aiMessage);
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

