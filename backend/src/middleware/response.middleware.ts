import { Request, Response, NextFunction } from 'express';
import { success, error, paginated } from '../utils/response.util';

export const responseHandler = (
  _req: Request,
  res: Response,
  next: NextFunction,
): void => {
  res.success = (data, message = 'OK', statusCode = 200) => {
    res.status(statusCode).json(success(data, message, statusCode));
  };

  res.error = (message, statusCode = 500, details?) => {
    res.status(statusCode).json(error(message, statusCode, details));
  };

  res.paginated = (data, pagination, message = 'OK', statusCode = 200) => {
    res
      .status(statusCode)
      .json(paginated(data, pagination, message, statusCode));
  };

  next();
};

