import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:mrs_unkwn_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mrs_unkwn_app/features/family/data/repositories/family_repository_impl.dart';
import 'package:mrs_unkwn_app/core/storage/secure_storage_service.dart';
import 'package:mrs_unkwn_app/core/network/dio_client.dart';

class MockDioClient extends Mock implements DioClient {}
class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockDioClient dio;
  late MockSecureStorageService storage;
  late AuthRepositoryImpl authRepo;
  late FamilyRepository familyRepo;

  setUp(() {
    dio = MockDioClient();
    storage = MockSecureStorageService();
    authRepo = AuthRepositoryImpl(dioClient: dio, storageService: storage);
    familyRepo = FamilyRepository(dioClient: dio);
  });

  group('Auth API', () {
    test('login success stores tokens', () async {
      when(dio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: {
              'data': {
                'tokens': {
                  'accessToken': 'a',
                  'refreshToken': 'b',
                }
              }
            },
            requestOptions: RequestOptions(path: ''),
          ));

      final user = await authRepo.login('a@b.com', 'pass');
      expect(user.id, 'temporary');
      verify(storage.store(SecureStorageService.tokenKey, 'a')).called(1);
      verify(storage.store(SecureStorageService.refreshTokenKey, 'b')).called(1);
    });

    test('login server error throws', () async {
      when(dio.post<Map<String, dynamic>>(any, data: anyNamed('data')))
          .thenThrow(Exception('server'));

      expect(
        () => authRepo.login('a@b.com', 'pass'),
        throwsA(isA<Exception>()),
      );
    });

    test('login network error throws', () async {
      when(dio.post<Map<String, dynamic>>(any, data: anyNamed('data'))).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        () => authRepo.login('a@b.com', 'pass'),
        throwsA(isA<Exception>()),
      );
    });

    test('refresh token stores new tokens', () async {
      when(dio.post<Map<String, dynamic>>(any))
          .thenAnswer((_) async => Response(
                data: {
                  'data': {
                    'tokens': {
                      'accessToken': 'c',
                      'refreshToken': 'd',
                    }
                  }
                },
                requestOptions: RequestOptions(path: ''),
              ));

      await authRepo.refreshToken();

      verify(storage.store(SecureStorageService.tokenKey, 'c')).called(1);
      verify(storage.store(SecureStorageService.refreshTokenKey, 'd')).called(1);
    });

    test('logout clears tokens', () async {
      await authRepo.logout();
      verify(storage.delete(SecureStorageService.tokenKey)).called(1);
      verify(storage.delete(SecureStorageService.refreshTokenKey)).called(1);
    });
  });

  group('Family API', () {
    test('createFamily sends POST', () async {
      when(dio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            data: {'data': {'id': '1'}},
            requestOptions: RequestOptions(path: ''),
          ));

      final data = await familyRepo.createFamily('smith');
      expect(data['id'], '1');
      verify(dio.post<Map<String, dynamic>>(
        '/api/families',
        data: {'name': 'smith'},
      )).called(1);
    });

    test('updateFamily error throws', () async {
      when(dio.put<Map<String, dynamic>>(any, data: anyNamed('data')))
          .thenThrow(Exception('fail'));

      expect(
        () => familyRepo.updateFamily('1', 'new'),
        throwsA(isA<Exception>()),
      );
    });

    test('deleteFamily sends DELETE', () async {
      when(dio.delete<void>(any)).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 204,
          ));

      await familyRepo.deleteFamily('1');
      verify(dio.delete<void>('/api/families/1')).called(1);
    });

    test('addMember posts to member endpoint', () async {
      when(dio.post<void>(
        any,
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
          ));

      await familyRepo.addMember('1', 'u1');
      verify(dio.post<void>(
        '/api/families/1/members',
        data: {'userId': 'u1'},
      )).called(1);
    });
  });
}
