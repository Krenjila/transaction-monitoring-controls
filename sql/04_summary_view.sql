CREATE OR REPLACE VIEW control_summary AS
SELECT
    exception_type,
    COUNT(*) AS total_exceptions,
    SUM(amount) AS total_dollar_exposure
FROM control_exceptions
GROUP BY exception_type;
