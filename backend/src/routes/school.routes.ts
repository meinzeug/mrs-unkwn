import { Router } from 'express';
import { body } from 'express-validator';
import { ldapService } from '../integrations/ldap.service';
import { ssoService } from '../integrations/sso.service';
import { validateRequest } from '../middleware/validation.middleware';

const router = Router();

router.post(
  '/ldap/login',
  validateRequest([
    body('username').notEmpty().withMessage('username required'),
    body('password').notEmpty().withMessage('password required')
  ]),
  async (req, res, next) => {
    const { username, password } = req.body;
    try {
      const user = await ldapService.authenticate(username, password);
      if (!user) {
        return res.status(401).json({ success: false, message: 'Invalid credentials' });
      }
      res.json({ success: true, data: user, message: 'LDAP authentication successful' });
    } catch (err) {
      next(err);
    }
  }
);

router.post('/sso/assert', async (req, res, next) => {
  const { samlResponse } = req.body;
  try {
    const profile = await ssoService.validate(samlResponse);
    res.json({ success: true, data: profile, message: 'SSO validation successful' });
  } catch (err) {
    next(err);
  }
});

export default router;

