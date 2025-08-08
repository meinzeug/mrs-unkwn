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

  // Authentication bypass: no token should return 401
  const res1 = await fetch(`${baseUrl}/api/user/profile`);
  assert.strictEqual(res1.status, 401);

  // Token validation: invalid token should return 401
  const res2 = await fetch(`${baseUrl}/api/user/profile`, {
    headers: { Authorization: 'Bearer invalid' },
  });
  assert.strictEqual(res2.status, 401);

  // Input sanitization: malformed login payload should be rejected
  const res3 = await fetch(`${baseUrl}/api/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      email: "admin@example.com' OR '1'='1",
      password: 'foo',
    }),
  });
  assert.strictEqual(res3.status, 400);

  console.log('Security tests passed');
  server.close();
});
