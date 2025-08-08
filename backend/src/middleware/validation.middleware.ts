import { Request, Response, NextFunction } from 'express';
import { ValidationChain, validationResult } from 'express-validator';

interface ValidationErrorItem {
  field: string;
  message: string;
}

interface ValidationErrorResponse {
  errors: ValidationErrorItem[];
}

export const validateRequest = (validations: ValidationChain[]) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    for (const validation of validations) {
      await validation.run(req);
    }

    const errors = validationResult(req);
    if (errors.isEmpty()) {
      return next();
    }

    const formatted: ValidationErrorResponse = {
      errors: errors.array().map(err => ({
        field: 'path' in err ? err.path : err.type,
        message: err.msg,
      })),
    };

    return res.error('Validation failed', 400, formatted);
  };
};
