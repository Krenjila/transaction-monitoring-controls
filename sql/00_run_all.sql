-- Drop and recreate transactions table
DROP TABLE IF EXISTS transactions;
\i 01_schema.sql

-- Load data (assumes CSV already copied into container)
\copy transactions(transaction_id, transaction_date, amount, vendor_id, vendor_name, vendor_country, department, invoice_id, payment_method, approver_id, approval_limit)
FROM '/transactions.csv'
WITH (FORMAT csv, HEADER true);

-- Drop and recreate exception table
DROP TABLE IF EXISTS control_exceptions;
\i 03_exceptions_table.sql

-- Run controls
\i 02_controls.sql
