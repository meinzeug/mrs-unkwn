import { Strategy as SamlStrategy, SamlConfig, Profile } from 'passport-saml';

class SsoService {
  private strategy: SamlStrategy | null = null;

  constructor() {
    const cert = process.env.SSO_CERT;
    if (cert) {
      const config: SamlConfig = {
        entryPoint: process.env.SSO_ENTRY_POINT || '',
        issuer: process.env.SSO_ISSUER || 'mrs-unkwn',
        cert,
        callbackUrl: process.env.SSO_CALLBACK_URL || ''
      };
      this.strategy = new SamlStrategy(config, () => {});
    }
  }

  validate(samlResponse: string): Promise<Profile> {
    if (!this.strategy) {
      return Promise.reject(new Error('SSO not configured'));
    }
    return new Promise((resolve, reject) => {
      this.strategy.validatePostResponse({ SAMLResponse: samlResponse } as any, (err, profile) => {
        if (err || !profile) {
          return reject(err || new Error('Invalid assertion'));
        }
        resolve(profile);
      });
    });
  }
}

export const ssoService = new SsoService();

