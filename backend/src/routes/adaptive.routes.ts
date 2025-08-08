import { Router } from 'express';
import { AdaptivePathService } from '../services/adaptive';

const router = Router();
const service = new AdaptivePathService();

router.post('/progress', async (req, res) => {
  const { userId, pathId = 'default', nodeId, success } = req.body;
  if (!userId || !nodeId || typeof success !== 'boolean') {
    return res.status(400).json({ error: 'Invalid payload' });
  }
  await service.recordResult(userId, pathId, nodeId, success);
  const next = await service.getNext(userId, pathId);
  res.json({ next });
});

export default router;
