import { Router, Request, Response } from 'express';
import { randomUUID } from 'crypto';
import { validateRequest } from '../middleware/validation.middleware';
import { userRegistrationSchema } from '../validation/schemas/userRegistration.schema';
import { userLoginSchema } from '../validation/schemas/userLogin.schema';
import { userRepository } from '../repositories/user.repository';
import { PasswordService } from '../services/password.service';
import { authService } from '../services/auth.service';

const router = Router();

interface RegisterBody {
  name: string;
  email: string;
  password: string;
  language?: string;
}

interface LoginBody {
  email: string;
  password: string;
}

router.post(
  '/register',
  validateRequest(userRegistrationSchema),
  async (req: Request<{}, {}, RegisterBody>, res: Response) => {
    const { name, email, password, language } = req.body;
    const existing = await userRepository.findByEmail(email);
    if (existing) {
      return res.error('User already exists', 409);
    }

    const password_hash = await PasswordService.hashPassword(password);
    const [first_name, ...rest] = name.split(' ');
    const last_name = rest.join(' ');

    const user = await userRepository.create({
      id: randomUUID(),
      email,
      password_hash,
      first_name,
      last_name,
      role: 'parent',
      language: language ?? 'en',
    });

    const tokens = authService.generateTokens(user.id);
    return res.success({ tokens }, 'User registered', 201);
  },
);

router.post(
  '/login',
  validateRequest(userLoginSchema),
  async (req: Request<{}, {}, LoginBody>, res: Response) => {
    const { email, password } = req.body;
    const user = await userRepository.findByEmail(email);
    if (!user) {
      return res.error('Invalid credentials', 401);
    }

    const valid = await PasswordService.comparePassword(password, user.password_hash);
    if (!valid) {
      return res.error('Invalid credentials', 401);
    }

    const tokens = authService.generateTokens(user.id);
    return res.success({ tokens }, 'Login successful');
  },
);

interface RefreshBody {
  refreshToken: string;
}

router.post(
  '/refresh',
  async (req: Request<{}, {}, RefreshBody>, res: Response) => {
    const { refreshToken } = req.body;
    if (!refreshToken) {
      return res.error('Refresh token required', 400);
    }

    try {
      const tokens = authService.refreshTokens(refreshToken);
      return res.success({ tokens }, 'Token refreshed');
    } catch {
      return res.error('Invalid token', 401);
    }
  },
);

interface LogoutBody {
  refreshToken: string;
}

router.post(
  '/logout',
  async (req: Request<{}, {}, LogoutBody>, res: Response) => {
    const accessToken = req.headers['authorization']?.split(' ')[1];
    const { refreshToken } = req.body;
    if (accessToken) {
      authService.blacklistToken(accessToken);
    }
    if (refreshToken) {
      authService.blacklistToken(refreshToken);
    }
    return res.success(null, 'Logged out');
  },
);

export default router;
