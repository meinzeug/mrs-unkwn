import crypto from 'crypto';
import { apiKeyRepository } from '../repositories/apiKey.repository';

class ApiKeyService {
  async generateKey(partnerName: string): Promise<string> {
    const key = crypto.randomBytes(32).toString('hex');
    await apiKeyRepository.create({ key, partner_name: partnerName });
    return key;
  }

  async validateKey(key: string): Promise<boolean> {
    const record = await apiKeyRepository.findByKey(key);
    return !!record && !record.revoked;
  }

  async revokeKey(key: string): Promise<void> {
    await apiKeyRepository.revoke(key);
  }

  async listKeys() {
    return apiKeyRepository.listAll();
  }
}

export const apiKeyService = new ApiKeyService();
