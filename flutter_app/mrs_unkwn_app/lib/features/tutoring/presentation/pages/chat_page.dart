import 'package:flutter/material.dart';

import '../../data/models/chat_message.dart';

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
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isLoadingMore = false;

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
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isLoadingMore = false);
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
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    return const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('AI is typing...'),
                    );
                  }
                  final uiMessage = _messages[index];
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
      child: Row(
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
            icon: const Icon(Icons.mic),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
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

