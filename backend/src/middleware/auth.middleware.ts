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
    res.error('Unauthorized', 401);
    return;
  }

  try {
    const payload = authService.verifyAccessToken(token);
    const user = await userRepository.findById(payload.userId);
    if (!user) {
      res.error('Unauthorized', 401);
      return;
    }
    req.user = user;
    next();
  } catch {
    res.error('Unauthorized', 401);
  }
};

export const authorizeRoles = (
  ...roles: User['role'][]
) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!req.user || !roles.includes(req.user.role)) {
      res.error('Forbidden', 403);
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
    res.error('Unauthorized', 401);
  }
};
