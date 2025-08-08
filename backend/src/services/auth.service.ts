import jwt from 'jsonwebtoken';
import { config } from '../config/config';

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
}

interface TokenPayload {
  userId: string;
  iat?: number;
  exp?: number;
}

class AuthService {
  private blacklistedTokens = new Set<string>();

  generateTokens(userId: string): TokenPair {
    const accessToken = jwt.sign({ userId }, config.jwtSecret, { expiresIn: '15m' });
    const refreshToken = jwt.sign({ userId }, config.jwtRefreshSecret, { expiresIn: '7d' });
    return { accessToken, refreshToken };
  }

  verifyAccessToken(token: string): TokenPayload {
    if (this.isTokenBlacklisted(token)) {
      throw new Error('Token blacklisted');
    }
    return jwt.verify(token, config.jwtSecret) as TokenPayload;
  }

  verifyRefreshToken(token: string): TokenPayload {
    if (this.isTokenBlacklisted(token)) {
      throw new Error('Token blacklisted');
    }
    return jwt.verify(token, config.jwtRefreshSecret) as TokenPayload;
  }

  refreshTokens(refreshToken: string): TokenPair {
    const payload = this.verifyRefreshToken(refreshToken);
    this.blacklistToken(refreshToken);
    return this.generateTokens(payload.userId);
  }

  blacklistToken(token: string): void {
    this.blacklistedTokens.add(token);
  }

  isTokenBlacklisted(token: string): boolean {
    return this.blacklistedTokens.has(token);
  }
}

export const authService = new AuthService();
