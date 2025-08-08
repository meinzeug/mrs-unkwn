import { Knex } from 'knex';

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable('organizations', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('uuid_generate_v4()'));
    table.string('name').notNullable();
    table.timestamps(true, true);
  });

  await knex.schema.createTable('user_organizations', (table) => {
    table.uuid('user_id').references('id').inTable('users').onDelete('CASCADE');
    table
      .uuid('organization_id')
      .references('id')
      .inTable('organizations')
      .onDelete('CASCADE');
    table.enu('role', ['admin', 'member']).notNullable().defaultTo('member');
    table.primary(['user_id', 'organization_id']);
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTableIfExists('user_organizations');
  await knex.schema.dropTableIfExists('organizations');
}
