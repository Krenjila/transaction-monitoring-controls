-- Run order for the project

\i 01_schema.sql
\i 03_exceptions_table.sql

-- clear old results (safe for re-runs)
DELETE FROM control_exceptions;

\i 02_controls.sql
