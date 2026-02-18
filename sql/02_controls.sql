-- ================================
-- Transaction Monitoring Controls
-- ================================

-- 1) Duplicate Invoice Payment Detection (report)
SELECT
    vendor_id,
    vendor_name,
    invoice_id,
    COUNT(*) AS duplicate_count,
    SUM(amount) AS total_paid
FROM transactions
GROUP BY vendor_id, vendor_name, invoice_id
HAVING COUNT(*) > 1;

-- 2) Approval Limit Breach Detection (report)
SELECT
    transaction_id,
    transaction_date,
    department,
    vendor_id,
    vendor_name,
    amount,
    approver_id,
    approval_limit
FROM transactions
WHERE amount > approval_limit
ORDER BY amount DESC;

-- 3) Potential Split Payment Detection (report)
SELECT
    vendor_id,
    vendor_name,
    transaction_date,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY vendor_id, vendor_name, transaction_date
HAVING COUNT(*) > 1
   AND SUM(amount) > 10000
ORDER BY total_amount DESC;

-- ================================
-- Insert exceptions into table
-- (safe re-runs handled by DELETE in 00_run_all.sql)
-- ================================

-- A) Approval limit breaches
INSERT INTO control_exceptions (
  exception_type, transaction_id, vendor_id, vendor_name, transaction_date, amount, detail
)
SELECT
  'Approval Limit Breach',
  t.transaction_id,
  t.vendor_id,
  t.vendor_name,
  t.transaction_date,
  t.amount,
  'Amount exceeds approval limit'
FROM transactions t
WHERE t.amount > t.approval_limit;

-- B) Duplicate invoice payments (same vendor + same invoice_id appears more than once)
INSERT INTO control_exceptions (
  exception_type, transaction_id, vendor_id, vendor_name, transaction_date, amount, detail
)
SELECT
  'Duplicate Invoice Payment',
  t.transaction_id,
  t.vendor_id,
  t.vendor_name,
  t.transaction_date,
  t.amount,
  'Same vendor + same invoice_id appears multiple times'
FROM transactions t
WHERE EXISTS (
  SELECT 1
  FROM transactions x
  WHERE x.vendor_id = t.vendor_id
    AND x.invoice_id = t.invoice_id
    AND x.transaction_id <> t.transaction_id
);

-- C) Potential split payments (same vendor + same day, total > 10,000)
INSERT INTO control_exceptions (
  exception_type, transaction_id, vendor_id, vendor_name, transaction_date, amount, detail
)
SELECT
  'Potential Split Payment',
  t.transaction_id,
  t.vendor_id,
  t.vendor_name,
  t.transaction_date,
  t.amount,
  'Multiple payments same vendor/date; total > 10,000'
FROM transactions t
JOIN (
  SELECT vendor_id, transaction_date
  FROM transactions
  GROUP BY vendor_id, transaction_date
  HAVING COUNT(*) > 1 AND SUM(amount) > 10000
) s
  ON s.vendor_id = t.vendor_id
 AND s.transaction_date = t.transaction_date;
