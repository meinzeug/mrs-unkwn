import '../../../../core/network/dio_client.dart';
import '../models/family.dart';
import '../models/create_family_request.dart';
import '../models/update_family_request.dart';
import '../models/invite_member_request.dart';
import '../models/family_settings.dart';
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

  /// Sends an invitation to join a family and returns the invitation token.
  @override
  Future<String> inviteMember(InviteMemberRequest request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/family/invite',
        data: request.toJson(),
      );
      final token = response.data?['data']?['token'] as String?;
      if (token == null) {
        throw Exception('Invalid response format');
      }
      return token;
    } catch (e) {
      throw Exception('Invite member failed: $e');
    }
  }

  /// Accepts an invitation token and returns the updated family.
  @override
  Future<Family> acceptInvitation(String token) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/family/invite/accept',
        data: {'token': token},
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      return Family.fromJson(data);
    } catch (e) {
      throw Exception('Accept invitation failed: $e');
    }
  }

  /// Retrieves family settings by [familyId].
  @override
  Future<FamilySettings> getSettings(String familyId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/api/families/$familyId/settings',
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      return FamilySettings.fromJson(data);
    } catch (e) {
      throw Exception('Get settings failed: $e');
    }
  }

  /// Updates family settings for [familyId].
  @override
  Future<FamilySettings> updateSettings(
    String familyId,
    FamilySettings settings,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/families/$familyId/settings',
        data: settings.toJson(),
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      return FamilySettings.fromJson(data);
    } catch (e) {
      throw Exception('Update settings failed: $e');
    }
  }

  /// Updates the role of a member within a family.
  @override
  Future<Family> updateMemberRole(
    String familyId,
    String userId,
    FamilyRole role,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/families/$familyId/members/$userId/role',
        data: {'role': role.name},
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      return Family.fromJson(data);
    } catch (e) {
      throw Exception('Update member role failed: $e');
    }
  }

  /// Updates permissions of a member within a family.
  @override
  Future<Family> updateMemberPermissions(
    String familyId,
    String userId,
    List<String> permissions,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/api/families/$familyId/members/$userId/permissions',
        data: {'permissions': permissions},
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      return Family.fromJson(data);
    } catch (e) {
      throw Exception('Update permissions failed: $e');
    }
  }

  /// Removes a member from the family.
  @override
  Future<Family> removeMember(String familyId, String userId) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '/api/families/$familyId/members/$userId',
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Invalid response format');
      }
      return Family.fromJson(data);
    } catch (e) {
      throw Exception('Remove member failed: $e');
    }
  }
}
