CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    amount NUMERIC(12,2),
    vendor_id INT,
    vendor_name TEXT,
    vendor_country TEXT,
    department TEXT,
    invoice_id TEXT,
    payment_method TEXT,
    approver_id TEXT,
    approval_limit NUMERIC(12,2)
);
