import { Request, Response, NextFunction } from 'express';
import { rolePermissions, FamilyPermission } from '../utils/familyPermissions';

export const authorizeFamilyPermission = (
  permission: FamilyPermission,
) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const role = req.user?.role;
    if (!role || !rolePermissions[role]?.includes(permission)) {
      res.error('Forbidden', 403);
      return;
    }
    next();
  };
};
