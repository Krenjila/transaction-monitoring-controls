-- Table to store flagged exceptions from control tests

CREATE TABLE IF NOT EXISTS control_exceptions (
    exception_id SERIAL PRIMARY KEY,
    exception_type TEXT NOT NULL,
    transaction_id INT,
    vendor_id INT,
    vendor_name TEXT,
    transaction_date DATE,
    amount NUMERIC(12,2),
    detail TEXT,
    flagged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
