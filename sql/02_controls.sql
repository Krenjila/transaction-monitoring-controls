-- Approval Limit Breaches
INSERT INTO control_exceptions (
  exception_type,
  transaction_id,
  vendor_id,
  vendor_name,
  transaction_date,
  amount,
  detail
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

-- Duplicate Invoice Payments
INSERT INTO control_exceptions (
  exception_type,
  transaction_id,
  vendor_id,
  vendor_name,
  transaction_date,
  amount,
  detail
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

-- Potential Split Payments
INSERT INTO control_exceptions (
  exception_type,
  transaction_id,
  vendor_id,
  vendor_name,
  transaction_date,
  amount,
  detail
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
