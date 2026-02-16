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
