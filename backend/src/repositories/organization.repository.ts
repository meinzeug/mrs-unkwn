import { db } from '../database/connection';

export interface Organization {
  id: string;
  name: string;
  created_at?: Date;
  updated_at?: Date;
}

export interface UserOrganization {
  user_id: string;
  organization_id: string;
  role: 'admin' | 'member';
}

export class OrganizationRepository {
  async create(name: string): Promise<Organization> {
    const [org] = await db<Organization>('organizations')
      .insert({ name })
      .returning(['id', 'name', 'created_at', 'updated_at']);
    return org;
  }

  async addUser(organization_id: string, user_id: string, role: 'admin' | 'member'): Promise<void> {
    await db<UserOrganization>('user_organizations').insert({
      organization_id,
      user_id,
      role,
    });
  }

  async findByUser(user_id: string): Promise<Array<Organization & { role: string }>> {
    return db<Organization>('organizations as o')
      .select('o.id', 'o.name', 'o.created_at', 'o.updated_at', 'uo.role')
      .join('user_organizations as uo', 'o.id', 'uo.organization_id')
      .where('uo.user_id', user_id);
  }
}

export const organizationRepository = new OrganizationRepository();
