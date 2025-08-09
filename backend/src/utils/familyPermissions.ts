import { User } from '../repositories/user.repository';

export type FamilyPermission =
  | 'MANAGE_MEMBERS'
  | 'VIEW_ACTIVITY'
  | 'EDIT_SETTINGS'
  | 'DELETE_FAMILY';

export const rolePermissions: Record<User['role'], FamilyPermission[]> = {
  parent: ['MANAGE_MEMBERS', 'VIEW_ACTIVITY', 'EDIT_SETTINGS', 'DELETE_FAMILY'],
  child: ['VIEW_ACTIVITY'],
};
