import { Router, Request, Response } from 'express';
import { authenticateToken } from '../middleware/auth.middleware';
import { userRepository } from '../repositories/user.repository';

const router = Router();

router.get('/profile', authenticateToken, (req: Request, res: Response) => {
  if (!req.user) {
    return res.error('Unauthorized', 401);
  }
  const { password_hash, ...user } = req.user;
  return res.success({ user });
});

router.put('/profile', authenticateToken, async (req: Request, res: Response) => {
  if (!req.user) {
    return res.error('Unauthorized', 401);
  }
  const { first_name, last_name } = req.body as {
    first_name?: string;
    last_name?: string;
  };
  const updated = await userRepository.update(req.user.id, {
    first_name: first_name ?? req.user.first_name,
    last_name: last_name ?? req.user.last_name,
  });
  const { password_hash, ...user } = updated;
  return res.success({ user }, 'Profile updated');
});

router.delete('/account', authenticateToken, async (req: Request, res: Response) => {
  if (!req.user) {
    return res.error('Unauthorized', 401);
  }
  await userRepository.delete(req.user.id);
  return res.success(null, 'Account deleted');
});

export default router;
