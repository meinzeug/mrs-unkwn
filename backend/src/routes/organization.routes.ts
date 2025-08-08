import { Router, Request, Response } from 'express';
import { body, param } from 'express-validator';
import { authenticateToken } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validation.middleware';
import { organizationService } from '../services/organization.service';

const router = Router();

router.post(
  '/',
  authenticateToken,
  [body('name').isString()],
  validateRequest,
  async (req: Request, res: Response) => {
    const { name } = req.body as { name: string };
    const org = await organizationService.createOrganization(name, req.user!.id);
    return res.success({ organization: org }, 'Organization created');
  },
);

router.post(
  '/:id/users',
  authenticateToken,
  [
    param('id').isUUID(),
    body('userId').isUUID(),
    body('role').isIn(['admin', 'member']),
  ],
  validateRequest,
  async (req: Request, res: Response) => {
    const { id } = req.params as { id: string };
    const { userId, role } = req.body as { userId: string; role: 'admin' | 'member' };
    await organizationService.addUser(id, userId, role);
    return res.success(null, 'User added to organization');
  },
);

router.get('/', authenticateToken, async (req: Request, res: Response) => {
  const orgs = await organizationService.getUserOrganizations(req.user!.id);
  return res.success({ organizations: orgs });
});

export default router;
