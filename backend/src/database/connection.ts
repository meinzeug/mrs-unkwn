import knex, { Knex } from 'knex';
import { config } from '../config/config';

const knexConfig: Knex.Config = {
  client: 'pg',
  connection: config.databaseUrl,
  pool: { min: 0, max: 10 },
};

export const db = knex(knexConfig);

export async function testConnection(): Promise<void> {
  try {
    await db.raw('select 1+1 as result');
    console.log('Database connection successful');
  } catch (error) {
    console.error('Database connection failed', error);
    throw error;
  } finally {
    await db.destroy();
  }
}

if (require.main === module) {
  testConnection()
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
}
