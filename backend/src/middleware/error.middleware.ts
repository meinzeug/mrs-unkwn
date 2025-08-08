import { Request, Response, NextFunction } from 'express';
import { config } from '../config/config';
import { error as formatError } from '../utils/response.util';

interface AppError extends Error {
  statusCode?: number;
  code?: string;
  details?: unknown;
}

export const errorHandler = (
  err: AppError,
  _req: Request,
  res: Response,
  _next: NextFunction,
): void => {
  let statusCode = err.statusCode || 500;
  let code = err.code || 'INTERNAL_ERROR';

  switch (err.name) {
    case 'ValidationError':
      statusCode = 400;
      code = 'VALIDATION_ERROR';
      break;
    case 'DatabaseError':
      statusCode = 500;
      code = 'DATABASE_ERROR';
      break;
    case 'AuthenticationError':
      statusCode = 401;
      code = 'AUTH_ERROR';
      break;
  }

  const details: Record<string, unknown> = { code };

  if (err.details) {
    details.details = err.details;
  }

  if (config.nodeEnv !== 'production' && err.stack) {
    details.stack = err.stack;
  }

  res
    .status(statusCode)
    .json(formatError(err.message || 'Internal Server Error', statusCode, details));
};
