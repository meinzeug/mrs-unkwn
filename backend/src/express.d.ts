import { User } from './repositories/user.repository';

declare global {
  namespace Express {
    interface Request {
      user?: User;
    }
  }
}

export {};
