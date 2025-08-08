import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../models/chat_message.dart';

/// Manages persistent storage of chat messages using Hive with encryption.
class ChatHistoryService {
  ChatHistoryService(this._secureStorage);

  final SecureStorageService _secureStorage;
  static const _boxName = 'chat_history';
  static const Duration defaultRetention = Duration(days: 30);
  static bool _initialized = false;
  Box? _box;

  /// Initializes Hive and opens the encrypted box.
  Future<void> init() async {
    if (!_initialized) {
      await Hive.initFlutter();
      _initialized = true;
    }
    if (!Hive.isBoxOpen(_boxName)) {
      final key = await _loadKey();
      _box = await Hive.openBox(_boxName, encryptionCipher: HiveAesCipher(key));
    } else {
      _box = Hive.box(_boxName);
    }
  }

  Future<List<int>> _loadKey() async {
    final existing = await _secureStorage.read(SecureStorageService.chatKey);
    if (existing != null) {
      return base64Url.decode(existing);
    }
    final key = Hive.generateSecureKey();
    await _secureStorage.store(
      SecureStorageService.chatKey,
      base64UrlEncode(key),
    );
    return key;
  }

  /// Adds [message] to history and triggers cleanup.
  Future<void> addMessage(ChatMessage message) async {
    await init();
    await _box!.put(message.id, message.toJson());
    await cleanup();
  }

  /// Returns all stored chat messages ordered by timestamp.
  Future<List<ChatMessage>> getMessages() async {
    await init();
    final messages = _box!.values.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return ChatMessage.fromJson(map);
    }).toList();
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  /// Searches messages by [keyword] and optional [from]/[to] range.
  Future<List<ChatMessage>> search({
    String? keyword,
    DateTime? from,
    DateTime? to,
  }) async {
    final messages = await getMessages();
    return messages.where((m) {
      final matchesKeyword =
          keyword == null || m.content.toLowerCase().contains(keyword.toLowerCase());
      final matchesFrom = from == null || !m.timestamp.isBefore(from);
      final matchesTo = to == null || !m.timestamp.isAfter(to);
      return matchesKeyword && matchesFrom && matchesTo;
    }).toList();
  }

  /// Exports chat history to [path] as JSON file.
  Future<File> exportToFile(String path) async {
    final messages = await getMessages();
    final file = File(path);
    await file.writeAsString(jsonEncode(messages.map((m) => m.toJson()).toList()));
    return file;
  }

  /// Creates a JSON string backup of all chats.
  Future<String> backup() async {
    final messages = await getMessages();
    return jsonEncode(messages.map((m) => m.toJson()).toList());
  }

  /// Restores chat history from [json] backup.
  Future<void> restore(String json) async {
    await init();
    final data = jsonDecode(json) as List;
    for (final item in data) {
      final msg = ChatMessage.fromJson(Map<String, dynamic>.from(item));
      await _box!.put(msg.id, msg.toJson());
    }
  }

  /// Removes messages older than [retention] period.
  Future<void> cleanup({Duration retention = defaultRetention}) async {
    await init();
    final cutoff = DateTime.now().subtract(retention);
    final keys = _box!.keys.where((key) {
      final map = Map<String, dynamic>.from(_box!.get(key));
      final ts = DateTime.parse(map['timestamp'] as String);
      return ts.isBefore(cutoff);
    }).toList();
    await _box!.deleteAll(keys);
  }
}

