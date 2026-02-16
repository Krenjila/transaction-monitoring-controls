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
