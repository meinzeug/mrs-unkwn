import { Request, Response, NextFunction } from 'express';
import { apiKeyService } from '../services/apiKey.service';

export const verifyApiKey = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  const key = req.headers['x-api-key'];
  if (typeof key !== 'string') {
    res.error('API key required', 401);
    return;
  }
  const valid = await apiKeyService.validateKey(key);
  if (!valid) {
    res.error('Invalid API key', 403);
    return;
  }
  next();
};
