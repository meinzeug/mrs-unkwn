import assert from 'node:assert';
import { AddressInfo } from 'node:net';

process.env.DATABASE_URL = 'postgres://user:pass@localhost:5432/test';
process.env.JWT_SECRET = 'test-secret';
process.env.JWT_REFRESH_SECRET = 'test-refresh';
process.env.EMAIL_SERVICE_KEY = 'test-email';
process.env.NODE_ENV = 'test';

import app from '../src/index';
import { apiKeyService } from '../src/services/apiKey.service';

(apiKeyService as any).validateKey = async (key: string) => key === 'valid-key';

const server = app.listen(0, async () => {
  const port = (server.address() as AddressInfo).port;
  const baseUrl = `http://localhost:${port}`;

  const ok = await fetch(`${baseUrl}/api/external/health`, {
    headers: { 'x-api-key': 'valid-key' },
  });
  assert.strictEqual(ok.status, 200);

  const bad = await fetch(`${baseUrl}/api/external/health`, {
    headers: { 'x-api-key': 'invalid-key' },
  });
  assert.strictEqual(bad.status, 403);

  const missing = await fetch(`${baseUrl}/api/external/health`);
  assert.strictEqual(missing.status, 401);

  console.log('External API tests passed');
  server.close();
});
