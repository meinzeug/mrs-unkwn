import { Request, Response, NextFunction } from 'express';
import { authService } from '../services/auth.service';
import { userRepository, User } from '../repositories/user.repository';

const extractToken = (header?: string) =>
  header?.startsWith('Bearer ') ? header.split(' ')[1] : undefined;

export const authenticateToken = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  const token = extractToken(req.headers['authorization']);
  if (!token) {
    res.status(401).json({ message: 'Unauthorized' });
    return;
  }

  try {
    const payload = authService.verifyAccessToken(token);
    const user = await userRepository.findById(payload.userId);
    if (!user) {
      res.status(401).json({ message: 'Unauthorized' });
      return;
    }
    req.user = user;
    next();
  } catch {
    res.status(401).json({ message: 'Unauthorized' });
  }
};

export const authorizeRoles = (
  ...roles: User['role'][]
) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!req.user || !roles.includes(req.user.role)) {
      res.status(403).json({ message: 'Forbidden' });
      return;
    }
    next();
  };
};

export const optionalAuth = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  const token = extractToken(req.headers['authorization']);
  if (!token) {
    next();
    return;
  }

  try {
    const payload = authService.verifyAccessToken(token);
    const user = await userRepository.findById(payload.userId);
    if (user) {
      req.user = user;
    }
    next();
  } catch {
    res.status(401).json({ message: 'Unauthorized' });
  }
};
