import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/models/chat_message.dart';
import '../../data/services/chat_history_service.dart';
import '../../data/services/voice_input_service.dart';
import '../../../../core/di/service_locator.dart';
import '../bloc/tutoring_bloc.dart';

enum MessageStatus { sending, sent, error }

class UiMessage {
  ChatMessage message;
  MessageStatus status;
  UiMessage({required this.message, required this.status});
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<UiMessage> _messages = [];
  final List<ChatMessage> _history = [];
  static const int _pageSize = 20;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isLoadingMore = false;
  final VoiceInputService _voice = VoiceInputService();
  final ChatHistoryService _historyService = sl<ChatHistoryService>();
  bool _isRecording = false;
  double _soundLevel = 0;
  Timer? _recordTimer;
  int _recordSeconds = 0;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final stored = await _historyService.getMessages();
    _history.addAll(stored);
    final start = max(0, _history.length - _pageSize);
    final initial = _history.sublist(start);
    setState(() {
      _messages.addAll(
        initial.map(
          (m) => UiMessage(message: m, status: MessageStatus.sent),
        ),
      );
    });
    _scrollToBottom();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: ChatRole.user,
      type: ChatMessageType.text,
      content: text,
      timestamp: DateTime.now(),
    );
    final uiMessage = UiMessage(message: message, status: MessageStatus.sending);
    setState(() {
      _messages.add(uiMessage);
      _controller.clear();
    });
    _scrollToBottom();
    unawaited(_historyService.addMessage(message));
    sl<TutoringBloc>().add(SendMessageRequested(text, age: 14));

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        uiMessage.status = MessageStatus.sent;
        _isTyping = true;
      });
      _simulateAiResponse(text);
    }).catchError((_) {
      setState(() {
        uiMessage.status = MessageStatus.error;
      });
    });
  }

  void _clearChat() {
    setState(() => _messages.clear());
  }

  void _handleVoiceResult(String text) {
    final lower = text.toLowerCase();
    if (lower == 'senden' || lower == 'send') {
      _sendMessage();
    } else if (lower == 'chat leeren' || lower == 'clear chat') {
      _clearChat();
    } else {
      setState(() => _controller.text = text);
      _sendMessage();
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _voice.stop();
      _recordTimer?.cancel();
      setState(() {
        _isRecording = false;
        _soundLevel = 0;
        _recordSeconds = 0;
      });
      return;
    }
    await _voice.start(
      onResult: _handleVoiceResult,
      onSoundLevel: (level) => setState(() => _soundLevel = level.clamp(0, 120)),
      onError: (msg) =>
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg))),
    );
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _recordSeconds++);
    });
    setState(() => _isRecording = true);
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _simulateAiResponse(String userText) {
    Future.delayed(const Duration(seconds: 1), () {
      final response = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: ChatRole.assistant,
        type: ChatMessageType.text,
        content: 'AI response to: $userText',
        timestamp: DateTime.now(),
      );
      setState(() {
        _messages.add(UiMessage(message: response, status: MessageStatus.sent));
        _isTyping = false;
      });
      _scrollToBottom();
      unawaited(_historyService.addMessage(response));
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    final startIndex = _history.length - _messages.length;
    if (startIndex <= 0) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 300));
    final newStart = max(0, startIndex - _pageSize);
    final older = _history.sublist(newStart, startIndex);
    setState(() {
      _messages.insertAll(
        0,
        older.map((m) => UiMessage(message: m, status: MessageStatus.sent)),
      );
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scroll) {
                if (scroll.metrics.pixels <=
                    scroll.metrics.minScrollExtent + 50) {
                  _loadMore();
                }
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount:
                    _messages.length + (_isTyping ? 1 : 0) + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoadingMore && index == 0) {
                    return const Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final msgIndex = index - (_isLoadingMore ? 1 : 0);
                  if (_isTyping && msgIndex == _messages.length) {
                    return const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('AI is typing...'),
                    );
                  }
                  final uiMessage = _messages[msgIndex];
                  return _ChatBubble(message: uiMessage);
                },
              ),
            ),
          ),
          const Divider(height: 1),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isRecording)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(value: _soundLevel / 120),
                  ),
                  const SizedBox(width: 8),
                  Text(_formatDuration(_recordSeconds)),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: 'Nachricht eingeben...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                onPressed: _toggleRecording,
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final UiMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.message.role == ChatRole.user;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUser ? Colors.blue[200] : Colors.grey[300];
    final statusIcon = {
      MessageStatus.sending: Icons.access_time,
      MessageStatus.sent: Icons.check,
      MessageStatus.error: Icons.error,
    }[message.status];

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Text(message.message.content),
            ),
            const SizedBox(height: 2),
            Icon(
              statusIcon,
              size: 12,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}

