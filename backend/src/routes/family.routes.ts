import { Router, Request, Response } from 'express';
import { body } from 'express-validator';
import { authenticateToken } from '../middleware/auth.middleware';
import { authorizeFamilyPermission } from '../middleware/permissions.middleware';
import { validateRequest } from '../middleware/validation.middleware';
import { familyService } from '../services/family.service';

const router = Router();

router.post(
  '/invite',
  authenticateToken,
  authorizeFamilyPermission('MANAGE_MEMBERS'),
  [
    body('familyId').isUUID(),
    body('email').isEmail(),
    body('role').isIn(['parent', 'child', 'guardian', 'admin']),
  ],
  validateRequest,
  (req: Request, res: Response) => {
    const { familyId, email, role } = req.body as {
      familyId: string;
      email: string;
      role: string;
    };
    familyService.inviteMember(familyId, email, role);
    return res.success(null, 'Invitation sent');
  },
);

router.post(
  '/invite/accept',
  [body('token').isString()],
  validateRequest,
  (req: Request, res: Response) => {
    try {
      const { token } = req.body as { token: string };
      const family = familyService.acceptInvitation(token);
      return res.success({ data: family }, 'Invitation accepted');
    } catch (e) {
      const message = e instanceof Error ? e.message : 'Error';
      return res.status(400).error(message);
    }
  },
);

export default router;
