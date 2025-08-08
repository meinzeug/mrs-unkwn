import '../../../../core/network/dio_client.dart';

/// Repository for family management API calls.
class FamilyRepository {
  FamilyRepository({DioClient? dioClient}) : _dio = dioClient ?? DioClient();

  final DioClient _dio;

  Future<Map<String, dynamic>> createFamily(String name) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/families',
        data: {'name': name},
      );
      return response.data?['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Create family failed: $e');
    }
  }

  Future<Map<String, dynamic>> updateFamily(String id, String name) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/families/$id',
        data: {'name': name},
      );
      return response.data?['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Update family failed: $e');
    }
  }

  Future<void> deleteFamily(String id) async {
    try {
      await _dio.delete<void>('/api/families/$id');
    } catch (e) {
      throw Exception('Delete family failed: $e');
    }
  }

  Future<void> addMember(String familyId, String userId) async {
    try {
      await _dio.post<void>(
        '/api/families/$familyId/members',
        data: {'userId': userId},
      );
    } catch (e) {
      throw Exception('Add member failed: $e');
    }
  }
}
