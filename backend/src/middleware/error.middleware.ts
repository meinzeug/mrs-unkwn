import { Request, Response, NextFunction } from 'express';
import { config } from '../config/config';

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

  const errorResponse: Record<string, unknown> = {
    message: err.message || 'Internal Server Error',
    code,
  };

  if (err.details) {
    errorResponse.details = err.details;
  }

  if (config.nodeEnv !== 'production' && err.stack) {
    errorResponse.stack = err.stack;
  }

  res.status(statusCode).json({ error: errorResponse });
};
