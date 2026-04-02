Transaction Monitoring & Internal Controls Framework
v2.0 — Risk Scoring Engine + Automated Audit Reporting

Executive Summary
This project simulates a transaction monitoring and internal controls environment using synthetic financial data (1,213 transactions). Three automated control tests detect approval limit breaches, duplicate invoice payments, and potential split payments — surfacing 214 exceptions representing $1.64M in financial exposure.
Version 2 extends the framework with a Python-based risk scoring engine and an automated Excel audit report, moving the system from detection to prioritization and delivery.

Whats New in v2?
Layer 1 — Risk Scoring Engine (python/risk_scoring.py)
Each flagged exception is assigned a severity of High, Medium, or Low based on three inputs:

Exception type — Control breaches rank highest, followed by duplicate invoices, then split payments
Transaction amount — Breaches under $2,000 over limit score Low; $2,000–$10,000 score Medium; above $10,000 score High. For non-breach exceptions, raw transaction amount is used.
Vendor country risk — High-risk jurisdictions (CN, KY, HK) trigger an escalation rule: no exception from a high-risk country can score below Medium, regardless of amount or type.

The final severity is the highest score across all three inputs after applying the escalation rule.
Layer 2 — Automated Excel Exception Report (python/04_excel_reporting.py)
A Python script using openpyxl generates a formatted, audit-ready Excel deliverable every time it runs. The report includes:

Header section — report title, generation date, and a severity breakdown summary (High / Medium / Low counts + total dollar exposure)
Color-coded rows — red for High, yellow for Medium, green for Low
Sorted by dollar exposure — highest-risk exceptions surface immediately
Frozen header row — usable at any scroll depth
214 exceptions | $1,644,580.93 total exposure | High: 168 | Medium: 20 | Low: 26


System Architecture
Python (generate_data.py)         → Synthetic transaction data (1,213 rows)
SQL (02_controls.sql)             → Control breach detection → 214 exceptions
SQL (04_summary_view.sql)         → Summary view by exception type
Python (risk_scoring.py)          → Severity scoring per exception
Python (04_excel_reporting.py)    → Automated formatted audit report
Power BI                          → Executive monitoring dashboard

Control Logic
ControlDefinitionApproval Limit Breachtransaction amount > approvers spending limitDuplicate Invoice PaymentSame vendor + same invoice ID appearing more than oncePotential Split PaymentSame vendor + same date, total payments exceed $10,000

Risk Scoring Rubric
InputLowMediumHighException TypeSplit PaymentDuplicate InvoiceControl BreachAmount< $2,000 over limit$2,000 – $10,000> $10,000Vendor CountryUS, UK, etc.Developing nationsCN, KY, HK
Escalation rule: Any exception involving a high-risk vendor country is automatically floored at Medium severity.
Final score: Highest of the three inputs after escalation.

Business Relevance
Undetected control failures create fraud risk and financial exposure. When approval limits are bypassed, invoices are paid twice, or payments are structured to avoid thresholds, companies face real monetary loss — often invisible until a formal audit.
This system moves from periodic review to continuous, automated monitoring. Every transaction is tested against control logic. Every exception is scored by risk. Every report is ready to hand to an audit team the moment it runs.

Key Metrics
MetricValueTotal Transactions1,213Total Exceptions214Total Dollar Exposure$1,644,580.93High Severity168Medium Severity20Low Severity26Breach Rate (avg across departments)63–72%

Tech Stack
Python · PostgreSQL · SQL · openpyxl · Power BI

Project Structure
transaction-monitoring-controls/
├── data/
│   ├── transactions.csv
│   └── exception_report.xlsx       ← generated audit report
├── python/
│   ├── generate_data.py
│   ├── risk_scoring.py             ← Layer 1: severity scoring engine
│   └── 04_excel_reporting.py       ← Layer 2: automated Excel report
├── sql/
│   ├── 00_run_all.sql
│   ├── 01_schema.sql
│   ├── 02_controls.sql
│   ├── 03_exceptions_table.sql
│   └── 04_summary_view.sql
├── powerbi/
└── README.md

How to Run
bash# Generate transactions
python3 python/generate_data.py

# Load into PostgreSQL and run controls
psql -U postgres -d analytics_db -f sql/00_run_all.sql

# Generate Excel audit report
cd python
python3 04_excel_reporting.py

Built by Krenjila Sharma — BS Computer Science & Business Analytics, Caldwell University
