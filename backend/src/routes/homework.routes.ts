import { Router } from 'express';
import { detectAIContent } from '../services/homework.service';

const router = Router();

router.post('/detect', async (req, res) => {
  const { text } = req.body;
  if (typeof text !== 'string') {
    return res.status(400).json({ error: 'text is required' });
  }
  try {
    const aiGenerated = await detectAIContent(text);
    res.json({ aiGenerated });
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
});

export default router;
