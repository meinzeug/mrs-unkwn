import { body } from 'express-validator';

export const userRegistrationSchema = [
  body('name')
    .trim()
    .notEmpty()
    .withMessage('Name is required'),
  body('email')
    .isEmail()
    .withMessage('Valid email is required'),
  body('password')
    .isStrongPassword({
      minLength: 8,
      minLowercase: 1,
      minUppercase: 1,
      minNumbers: 1,
      minSymbols: 1,
    })
    .withMessage('Password must be at least 8 characters long and include uppercase, lowercase, number and symbol'),
  body('language')
    .optional()
    .isIn(['en', 'de'])
    .withMessage('Language must be en or de'),
];
