import { AdaptivePathService } from '../src/services/adaptive';
import { AddressInfo } from 'net';

async function run() {
  const service = new AdaptivePathService();
  let next = await service.getNext('user1');
  if (!next || next.id !== 'intro') {
    throw new Error('Expected intro as first node');
  }
  await service.recordResult('user1', 'default', 'intro', true);
  next = await service.getNext('user1');
  if (!next || next.id !== 'advanced') {
    throw new Error('Expected advanced after intro');
  }

  process.env.DATABASE_URL = 'postgres://user:pass@localhost:5432/test';
  process.env.JWT_SECRET = 'test-secret';
  process.env.JWT_REFRESH_SECRET = 'test-refresh';
  process.env.EMAIL_SERVICE_KEY = 'test-email';
  process.env.NODE_ENV = 'test';

  const { default: app } = await import('../src/index');
  await new Promise<void>((resolve, reject) => {
    const server = app.listen(0, async () => {
      try {
        const port = (server.address() as AddressInfo).port;
        const res = await fetch(`http://localhost:${port}/api/adaptive/progress`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ userId: 'user2', nodeId: 'intro', success: true }),
        });
        const data = await res.json();
        if (!data.next || data.next.id !== 'advanced') {
          throw new Error('Expected advanced after posting progress');
        }
        server.close();
        resolve();
      } catch (err) {
        server.close();
        reject(err);
      }
    });
  });

  console.log('adaptive.test.ts passed');
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
