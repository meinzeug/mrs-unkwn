import { Router, Request, Response } from 'express';
import { body } from 'express-validator';
import { authenticateToken } from '../middleware/auth.middleware';
import { validateRequest } from '../middleware/validation.middleware';
import { userRepository } from '../repositories/user.repository';

const router = Router();

router.get('/profile', authenticateToken, (req: Request, res: Response) => {
  if (!req.user) {
    return res.error('Unauthorized', 401);
  }
  const { password_hash, ...user } = req.user;
  return res.success({ user });
});

router.put(
  '/profile',
  authenticateToken,
  [
    body('first_name').optional().isString(),
    body('last_name').optional().isString(),
    body('language').optional().isIn(['en', 'de']),
  ],
  validateRequest,
  async (req: Request, res: Response) => {
    if (!req.user) {
      return res.error('Unauthorized', 401);
    }
    const { first_name, last_name, language } = req.body as {
      first_name?: string;
      last_name?: string;
      language?: string;
    };
    const updated = await userRepository.update(req.user.id, {
      first_name: first_name ?? req.user.first_name,
      last_name: last_name ?? req.user.last_name,
      language: language ?? req.user.language,
    });
    const { password_hash, ...user } = updated;
    return res.success({ user }, 'Profile updated');
  },
);

router.delete('/account', authenticateToken, async (req: Request, res: Response) => {
  if (!req.user) {
    return res.error('Unauthorized', 401);
  }
  await userRepository.delete(req.user.id);
  return res.success(null, 'Account deleted');
});

export default router;
