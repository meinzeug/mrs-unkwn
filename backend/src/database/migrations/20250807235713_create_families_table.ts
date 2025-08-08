import type { Knex } from 'knex';

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable('families', (table) => {
    table.uuid('id').primary();
    table.string('name').notNullable();
    table
      .uuid('created_by')
      .notNullable()
      .references('id')
      .inTable('users')
      .onDelete('CASCADE');
    table.string('subscription_tier').notNullable();
    table.timestamps(true, true);
  });

  await knex.schema.createTable('family_members', (table) => {
    table.uuid('id').primary();
    table
      .uuid('family_id')
      .notNullable()
      .references('id')
      .inTable('families')
      .onDelete('CASCADE')
      .index();
    table
      .uuid('user_id')
      .notNullable()
      .references('id')
      .inTable('users')
      .onDelete('CASCADE')
      .index();
    table.string('role').notNullable();
    table.jsonb('permissions');
    table.timestamp('joined_at').defaultTo(knex.fn.now());
    table.unique(['family_id', 'user_id']);
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists('family_members');
  await knex.schema.dropTableIfExists('families');
}

