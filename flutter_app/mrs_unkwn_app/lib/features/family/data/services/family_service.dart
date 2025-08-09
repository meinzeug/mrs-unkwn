import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/family.dart';

/// Provides real-time synchronization of [Family] data with offline caching.
class FamilyService {
  FamilyService();

  static const _boxName = 'family_cache';
  static bool _initialized = false;

  Box? _box;
  WebSocketChannel? _channel;
  final _controller = StreamController<Family>.broadcast();

  /// Exposes a stream of family updates.
  Stream<Family> get familyStream => _controller.stream;

  /// Indicates whether a sync process is currently running.
  final ValueNotifier<bool> isSyncing = ValueNotifier(false);

  Future<void> _init() async {
    if (!_initialized) {
      await Hive.initFlutter();
      _initialized = true;
    }
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox(_boxName);
    } else {
      _box = Hive.box(_boxName);
    }
  }

  /// Returns cached family data if available.
  Future<Family?> getCachedFamily(String familyId) async {
    await _init();
    final data = _box!.get(familyId);
    if (data == null) return null;
    return Family.fromJson(Map<String, dynamic>.from(data as Map));
  }

  /// Connects to the server and listens for updates of [familyId].
  Future<void> connect(String familyId) async {
    await _init();
    isSyncing.value = true;
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://example.com/families/$familyId'),
    );
    _channel!.stream.listen(
      (message) async {
        final map = jsonDecode(message as String) as Map<String, dynamic>;
        final family = Family.fromJson(map);
        await _saveFamily(family);
        _controller.add(family);
        isSyncing.value = false;
      },
      onError: (_) => isSyncing.value = false,
    );
  }

  /// Disconnects the service and closes streams.
  Future<void> disconnect() async {
    await _channel?.sink.close();
    await _controller.close();
    isSyncing.value = false;
  }

  /// Stores [family] locally if it is newer than the cached version.
  Future<void> _saveFamily(Family family) async {
    final cached = await getCachedFamily(family.id);
    if (cached == null || cached.updatedAt.isBefore(family.updatedAt)) {
      await _box!.put(family.id, family.toJson());
    }
  }

  /// Saves a local update and sends it to the server.
  Future<void> saveLocalUpdate(Family family) async {
    await _init();
    await _saveFamily(family);
    final jsonStr = jsonEncode(family.toJson());
    isSyncing.value = true;
    _channel?.sink.add(jsonStr);
  }
}
