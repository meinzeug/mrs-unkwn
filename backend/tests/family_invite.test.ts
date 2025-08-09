import assert from 'node:assert';
import { AddressInfo } from 'node:net';

process.env.DATABASE_URL = 'postgres://user:pass@localhost:5432/test';
process.env.JWT_SECRET = 'test-secret';
process.env.JWT_REFRESH_SECRET = 'test-refresh';
process.env.EMAIL_SERVICE_KEY = 'test-email';
process.env.NODE_ENV = 'test';

import app from '../src/index';

const server = app.listen(0, async () => {
  const port = (server.address() as AddressInfo).port;
  const baseUrl = `http://localhost:${port}`;

  const res = await fetch(`${baseUrl}/api/family/invite`, { method: 'POST' });
  assert.strictEqual(res.status, 401);

  console.log('Family invite route security test passed');
  server.close();
});
