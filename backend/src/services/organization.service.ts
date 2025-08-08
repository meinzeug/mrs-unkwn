import { organizationRepository } from '../repositories/organization.repository';

class OrganizationService {
  async createOrganization(name: string, ownerId: string) {
    const org = await organizationRepository.create(name);
    await organizationRepository.addUser(org.id, ownerId, 'admin');
    return org;
  }

  async addUser(organizationId: string, userId: string, role: 'admin' | 'member') {
    await organizationRepository.addUser(organizationId, userId, role);
  }

  async getUserOrganizations(userId: string) {
    return organizationRepository.findByUser(userId);
  }
}

export const organizationService = new OrganizationService();
