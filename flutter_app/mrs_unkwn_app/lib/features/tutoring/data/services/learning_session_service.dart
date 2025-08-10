import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../models/learning_session.dart';

/// Manages persistence of [LearningSession]s and prepares them for backend sync.
class LearningSessionService {
  LearningSessionService(this._secureStorage);

  final SecureStorageService _secureStorage;
  static const _boxName = 'learning_sessions';
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
    final existing = await _secureStorage.read(SecureStorageService.sessionKey);
    if (existing != null) {
      return base64Url.decode(existing);
    }
    final key = Hive.generateSecureKey();
    await _secureStorage.store(
      SecureStorageService.sessionKey,
      base64UrlEncode(key),
    );
    return key;
  }

  /// Starts a new learning session and persists it.
  Future<LearningSession> startSession() async {
    await init();
    final session = LearningSession.start();
    await _box!.put(session.id, session.toJson());
    return session;
  }

  /// Retrieves a session by [id].
  Future<LearningSession?> getSession(String id) async {
    await init();
    final data = _box!.get(id);
    if (data == null) return null;
    return LearningSession.fromJson(Map<String, dynamic>.from(data as Map));
  }

  /// Persists an updated [session].
  Future<void> updateSession(LearningSession session) async {
    await init();
    await _box!.put(session.id, session.toJson());
  }

  /// Marks the session with [id] as ended and persists it.
  Future<LearningSession?> endSession(String id) async {
    final session = await getSession(id);
    if (session == null) return null;
    final ended = session.end();
    await updateSession(ended);
    return ended;
  }

  /// Returns all sessions that haven't been synced yet.
  Future<List<LearningSession>> unsyncedSessions() async {
    await init();
    return _box!.values
        .map((e) =>
            LearningSession.fromJson(Map<String, dynamic>.from(e as Map)))
        .where((s) => !s.isSynced)
        .toList();
  }
}
