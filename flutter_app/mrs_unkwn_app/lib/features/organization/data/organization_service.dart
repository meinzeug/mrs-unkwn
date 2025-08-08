import '../../../core/network/dio_client.dart';
import '../models/organization.dart';

class OrganizationService {
  final DioClient _client;
  OrganizationService(this._client);

  Future<List<Organization>> fetchOrganizations() async {
    final res = await _client.get('/organizations');
    final list = (res.data['organizations'] as List)
        .map((e) => Organization.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  Future<Organization> createOrganization(String name) async {
    final res = await _client.post('/organizations', data: {'name': name});
    return Organization.fromJson(res.data['organization']);
  }

  Future<void> addUser(String orgId, String userId, String role) async {
    await _client.post('/organizations/$orgId/users', data: {'userId': userId, 'role': role});
  }
}
