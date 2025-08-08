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
}

interface LoginBody {
  email: string;
  password: string;
}

router.post(
  '/register',
  validateRequest(userRegistrationSchema),
  async (req: Request<{}, {}, RegisterBody>, res: Response) => {
    const { name, email, password } = req.body;
    const existing = await userRepository.findByEmail(email);
    if (existing) {
      return res.status(409).json({ message: 'User already exists' });
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
    });

    const tokens = authService.generateTokens(user.id);
    return res.status(201).json({ tokens });
  },
);

router.post(
  '/login',
  validateRequest(userLoginSchema),
  async (req: Request<{}, {}, LoginBody>, res: Response) => {
    const { email, password } = req.body;
    const user = await userRepository.findByEmail(email);
    if (!user) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const valid = await PasswordService.comparePassword(password, user.password_hash);
    if (!valid) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const tokens = authService.generateTokens(user.id);
    return res.json({ tokens });
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
      return res.status(400).json({ message: 'Refresh token required' });
    }

    try {
      const tokens = authService.refreshTokens(refreshToken);
      return res.json({ tokens });
    } catch {
      return res.status(401).json({ message: 'Invalid token' });
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
    return res.status(204).send();
  },
);

export default router;
