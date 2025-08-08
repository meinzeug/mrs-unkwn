import 'package:flutter_test/flutter_test.dart';
import 'package:mrs_unkwn_app/core/storage/secure_storage_service.dart';

void main() {
  test('stores and retrieves secure data', () async {
    final storage = SecureStorageService();
    await storage.store(SecureStorageService.tokenKey, 'secret');
    final value = await storage.read(SecureStorageService.tokenKey);
    expect(value, 'secret');
    await storage.delete(SecureStorageService.tokenKey);
    final deleted = await storage.read(SecureStorageService.tokenKey);
    expect(deleted, isNull);
  });
}
