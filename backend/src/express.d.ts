import { User } from './repositories/user.repository';

declare global {
  namespace Express {
    interface Request {
      user?: User;
    }
    interface Response {
      success: (data: unknown, message?: string, statusCode?: number) => void;
      error: (
        message: string,
        statusCode?: number,
        details?: unknown,
      ) => void;
      paginated: (
        data: unknown,
        pagination: unknown,
        message?: string,
        statusCode?: number,
      ) => void;
    }
  }
}

export {};
