import type { Knex } from 'knex';
import dotenv from 'dotenv';

dotenv.config();

const config: { [key: string]: Knex.Config } = {
  development: {
    client: 'pg',
    connection: process.env.DATABASE_URL!,
    pool: { min: 0, max: 10 },
    migrations: {
      directory: './src/database/migrations',
      extension: 'ts',
    },
  },
};

export default config;
