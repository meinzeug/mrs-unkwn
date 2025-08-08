import rateLimit from 'express-rate-limit';

const max = parseInt(process.env.RATE_LIMIT_MAX || '100', 10);

export const externalRateLimiter = rateLimit({
  windowMs: 60 * 1000,
  max,
  standardHeaders: true,
  legacyHeaders: false,
});

