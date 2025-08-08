#!/bin/bash
set -e

if [ -z "$DATABASE_URL" ]; then
  echo "DATABASE_URL is not set"
  exit 1
fi

psql "$DATABASE_URL" <<'SQL'
INSERT INTO organizations (name) VALUES
  ('Sample Org A'),
  ('Sample Org B')
ON CONFLICT DO NOTHING;
SQL

echo "Sample organizations created"
