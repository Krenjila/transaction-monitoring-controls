-- 1. Duplicate Invoice Payment Detection
-- Same vendor + same invoice_id appearing more than once

SELECT
    vendor_id,
    vendor_name,
    invoice_id,
    COUNT(*) AS duplicate_count,
    SUM(amount) AS total_paid
FROM transactions
GROUP BY vendor_id, vendor_name, invoice_id
HAVING COUNT(*) > 1;
-- 2. Approval Limit Breach Detection
-- Amount exceeds the approval_limit for the approver

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
-- 3. Potential Split Payment Detection
-- Same vendor + same transaction_date where total exceeds 10,000

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
-- Insert Approval Limit Breaches into control_exceptions

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
    transaction_id,
    vendor_id,
    vendor_name,
    transaction_date,
    amount,
    'Amount exceeds approval limit'
FROM transactions
WHERE amount > approval_limit;
-- Insert Duplicate Invoice Payments into control_exceptions

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
JOIN (
    SELECT vendor_id, invoice_id
    FROM transactions
    GROUP BY vendor_id, invoice_id
    HAVING COUNT(*) > 1
) d
ON t.vendor_id = d.vendor_id AND t.invoice_id = d.invoice_id;
-- Insert Potential Split Payments into control_exceptions

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
ON t.vendor_id = s.vendor_id AND t.transaction_date = s.transaction_date;
