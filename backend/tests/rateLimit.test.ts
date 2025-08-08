import assert from 'node:assert';
import { AddressInfo } from 'node:net';

process.env.RATE_LIMIT_MAX = '5';
process.env.DATABASE_URL = 'postgres://user:pass@localhost:5432/test';
process.env.JWT_SECRET = 'test-secret';
process.env.JWT_REFRESH_SECRET = 'test-refresh';
process.env.EMAIL_SERVICE_KEY = 'test-email';
process.env.NODE_ENV = 'test';

import app from '../src/index';

const server = app.listen(0, async () => {
  const port = (server.address() as AddressInfo).port;
  const baseUrl = `http://localhost:${port}`;

  for (let i = 0; i < 5; i++) {
    const res = await fetch(`${baseUrl}/api/external/health`);
    assert.strictEqual(res.status, 401);
  }

  const res6 = await fetch(`${baseUrl}/api/external/health`);
  assert.strictEqual(res6.status, 429);

  console.log('Rate limit test passed');
  server.close();
});
