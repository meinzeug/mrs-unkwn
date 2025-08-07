import dotenv from 'dotenv';

dotenv.config();

const required = [
  'DATABASE_URL',
  'JWT_SECRET',
  'JWT_REFRESH_SECRET',
  'EMAIL_SERVICE_KEY',
  'NODE_ENV',
] as const;

type RequiredKeys = typeof required[number];

export interface Config {
  databaseUrl: string;
  jwtSecret: string;
  jwtRefreshSecret: string;
  emailServiceKey: string;
  nodeEnv: string;
}

function getConfig(): Config {
  const env: Partial<Record<RequiredKeys, string>> = {};
  for (const key of required) {
    const value = process.env[key];
    if (!value) {
      throw new Error(`Missing environment variable: ${key}`);
    }
    env[key] = value;
  }
  return {
    databaseUrl: env.DATABASE_URL!,
    jwtSecret: env.JWT_SECRET!,
    jwtRefreshSecret: env.JWT_REFRESH_SECRET!,
    emailServiceKey: env.EMAIL_SERVICE_KEY!,
    nodeEnv: env.NODE_ENV!,
  };
}

export const config = getConfig();
