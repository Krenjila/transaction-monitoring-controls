🛡 Transaction Monitoring & Internal Controls Framework

Overview

This project simulates a transaction-level monitoring system designed to detect control failures, approval threshold violations, and vendor concentration risk using SQL, Python, and Power BI.

The objective is to move from periodic review to continuous risk monitoring.



System Architecture
	•	Python → Synthetic transaction data generation
	•	SQL → Control breach detection + summary views
	•	Power BI → Executive monitoring dashboard



Key Risk Metrics
	•	Total Spend: $1.64M
	•	Total Breach Amount: $1.09M
	•	214 Transactions
	•	Breach rate across departments: 63–72%



Control Logic

A breach is defined as:

Transaction Amount > Approval Limit

Additional risk concentration analysis performed at:
	•	Department level
	•	Vendor level

⸻

Dashboard Insights

1. Department Risk Exposure

(Insert image from powerbi folder)

2. Control Breaches vs Spend



3. Spending vs Approval Threshold



4. Vendor Risk Concentration



⸻

Business Implications
	•	High breach concentration suggests weak preventive controls
	•	Vendor-level clustering indicates dependency risk
	•	Certain departments show threshold proximity patterns

⸻

Future Enhancements
	•	Risk scoring model
	•	Anomaly detection using statistical thresholds
	•	Automated exception flagging pipeline
