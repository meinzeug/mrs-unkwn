import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provides secure key-value storage.
class SecureStorageService {
  SecureStorageService._internal() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  static final SecureStorageService _instance = SecureStorageService._internal();

  /// Returns the singleton instance of [SecureStorageService].
  factory SecureStorageService() => _instance;

  late final FlutterSecureStorage _storage;

  /// Storage key for auth token.
  static const String tokenKey = 'TOKEN_KEY';

  /// Storage key for refresh token.
  static const String refreshTokenKey = 'REFRESH_TOKEN_KEY';

  /// Storage key for serialized user data.
  static const String userDataKey = 'USER_DATA_KEY';

  /// Storage key for chat encryption key.
  static const String chatKey = 'CHAT_KEY';

  /// Stores a value under the given [key].
  Future<void> store(String key, String value) => _storage.write(key: key, value: value);

  /// Reads a value for the given [key]. Returns `null` if not found.
  Future<String?> read(String key) => _storage.read(key: key);

  /// Deletes the value associated with the given [key].
  Future<void> delete(String key) => _storage.delete(key: key);

  /// Deletes all stored key-value pairs.
  Future<void> deleteAll() => _storage.deleteAll();
}
