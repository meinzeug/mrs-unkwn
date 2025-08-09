import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../presentation/bloc/auth_bloc.dart';

/// Implementation of [AuthRepository] using [DioClient] for HTTP requests.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    DioClient? dioClient,
    SecureStorageService? storageService,
  })  : _dio = dioClient ?? DioClient(),
        _storage = storageService ?? SecureStorageService();

  final DioClient _dio;
  final SecureStorageService _storage;

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      final tokens = data['tokens'] as Map<String, dynamic>;
      final accessToken = tokens['accessToken'] as String;
      final refreshToken = tokens['refreshToken'] as String;

      await _storage.store(SecureStorageService.tokenKey, accessToken);
      await _storage.store(
        SecureStorageService.refreshTokenKey,
        refreshToken,
      );

      return const User(id: 'temporary');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<User> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/auth/register',
        data: {
          'name': '$firstName $lastName',
          'email': email,
          'password': password,
          'role': role,
        },
      );

      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      final tokens = data['tokens'] as Map<String, dynamic>;
      final accessToken = tokens['accessToken'] as String;
      final refreshToken = tokens['refreshToken'] as String;

      await _storage.store(SecureStorageService.tokenKey, accessToken);
      await _storage.store(
        SecureStorageService.refreshTokenKey,
        refreshToken,
      );

      return const User(id: 'temporary');
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await _storage.read(SecureStorageService.tokenKey);
    final refresh = await _storage.read(SecureStorageService.refreshTokenKey);
    if (token == null || refresh == null) {
      return null;
    }
    try {
      final response = await _dio.get<Map<String, dynamic>>('/api/auth/me');
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        return null;
      }
      return const User(id: 'temporary');
    } catch (_) {
      try {
        await refreshToken();
        final response = await _dio.get<Map<String, dynamic>>('/api/auth/me');
        final data = response.data?['data'] as Map<String, dynamic>?;
        if (data == null) {
          return null;
        }
        return const User(id: 'temporary');
      } catch (_) {
        await logout();
        return null;
      }
    }
  }

  @override
  Future<void> refreshToken() async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/auth/refresh',
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      final tokens = data['tokens'] as Map<String, dynamic>;
      await _storage.store(
        SecureStorageService.tokenKey,
        tokens['accessToken'] as String,
      );
      await _storage.store(
        SecureStorageService.refreshTokenKey,
        tokens['refreshToken'] as String,
      );
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('/api/auth/logout');
    } catch (_) {
      // Ignore network errors during logout
    } finally {
      await _storage.deleteAll();
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(
        '/api/auth/forgot-password',
        data: {'email': email},
      );
    } catch (e) {
      throw Exception('Forgot password failed: $e');
    }
  }

  @override
  Future<User> resetPassword(String token, String newPassword) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/auth/reset-password',
        data: {
          'token': token,
          'password': newPassword,
        },
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      final tokens = data['tokens'] as Map<String, dynamic>;
      await _storage.store(
        SecureStorageService.tokenKey,
        tokens['accessToken'] as String,
      );
      await _storage.store(
        SecureStorageService.refreshTokenKey,
        tokens['refreshToken'] as String,
      );
      return const User(id: 'temporary');
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }
}
