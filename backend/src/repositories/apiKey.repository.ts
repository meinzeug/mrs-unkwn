import { db } from '../database/connection';

export interface ApiKey {
  id: string;
  key: string;
  partner_name: string;
  revoked: boolean;
  created_at?: Date;
  updated_at?: Date;
}

export type CreateApiKeyDTO = Omit<ApiKey, 'id' | 'revoked' | 'created_at' | 'updated_at'>;

export class ApiKeyRepository {
  async create(data: CreateApiKeyDTO): Promise<ApiKey> {
    const [apiKey] = await db<ApiKey>('api_keys')
      .insert({ ...data, revoked: false })
      .returning(['id', 'key', 'partner_name', 'revoked', 'created_at', 'updated_at']);
    return apiKey;
  }

  async findByKey(key: string): Promise<ApiKey | null> {
    const apiKey = await db<ApiKey>('api_keys').where({ key }).first();
    return apiKey || null;
  }

  async revoke(key: string): Promise<void> {
    await db<ApiKey>('api_keys').where({ key }).update({ revoked: true });
  }

  async listAll(): Promise<ApiKey[]> {
    return db<ApiKey>('api_keys').select(
      'id',
      'key',
      'partner_name',
      'revoked',
      'created_at',
      'updated_at',
    );
  }
}

export const apiKeyRepository = new ApiKeyRepository();
