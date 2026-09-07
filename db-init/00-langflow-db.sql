-- Dedicated database for Langflow's own persistence (flows, users, message history).
-- Kept separate from filament_db so Langflow's internal tables never mix with the
-- application schema in 01-schema.sql / 02-seed.sql.
--
-- NOTE: this only runs when the postgres_data volume is initialized from empty.
-- On an existing volume, create it manually:
--   docker exec filament-postgres psql -U filament -d postgres \
--     -c 'CREATE DATABASE langflow_db OWNER filament;'

SELECT 'CREATE DATABASE langflow_db OWNER filament'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'langflow_db')\gexec
