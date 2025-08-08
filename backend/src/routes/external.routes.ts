import { Router } from 'express';
import { verifyApiKey } from '../middleware/apiKey.middleware';
import { userRepository } from '../repositories/user.repository';

const router = Router();

router.get('/health', verifyApiKey, (_req, res) => {
  res.success({ status: 'ok' });
});

router.get('/users/:id', verifyApiKey, async (req, res) => {
  const user = await userRepository.findById(req.params.id);
  if (!user) {
    res.error('User not found', 404);
    return;
  }
  res.success(user);
});

export default router;
