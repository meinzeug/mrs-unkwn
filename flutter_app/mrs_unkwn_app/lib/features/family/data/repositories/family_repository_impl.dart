import '../../../../core/network/dio_client.dart';
import '../models/family.dart';
import '../models/create_family_request.dart';
import '../models/update_family_request.dart';
import 'family_repository.dart';

/// Repository for family management API calls.
class FamilyRepositoryImpl implements FamilyRepository {
  FamilyRepositoryImpl({DioClient? dioClient}) : _dio = dioClient ?? DioClient();

  final DioClient _dio;

  /// Creates a new family using [request] data.
  @override
  Future<Family> createFamily(CreateFamilyRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/families',
        data: request.toJson(),
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      return Family.fromJson(data);
    } catch (e) {
      throw Exception('Create family failed: $e');
    }
  }

  /// Retrieves a family by its [familyId].
  @override
  Future<Family> getFamily(String familyId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/families/$familyId',
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      return Family.fromJson(data);
    } catch (e) {
      throw Exception('Get family failed: $e');
    }
  }

  /// Updates an existing family with [familyId] using [request].
  @override
  Future<Family> updateFamily(
    String familyId,
    UpdateFamilyRequest request,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/families/$familyId',
        data: request.toJson(),
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      return Family.fromJson(data);
    } catch (e) {
      throw Exception('Update family failed: $e');
    }
  }

  /// Deletes the family with [familyId].
  @override
  Future<void> deleteFamily(String familyId) async {
    try {
      await _dio.delete<void>('/api/families/$familyId');
    } catch (e) {
      throw Exception('Delete family failed: $e');
    }
  }
}
