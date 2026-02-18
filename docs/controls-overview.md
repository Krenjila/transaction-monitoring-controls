Controls Overview

Objective

This system simulates a transaction-level monitoring environment designed to identify control failures in financial operations. The goal is to move from periodic review to continuous, data-driven control monitoring.

The controls implemented focus on high-risk transaction patterns commonly observed in internal audit and risk advisory engagements.


1. Approval Limit Breach Detection

Control Logic:
Flag transactions where:
  transaction_amount > approval_limit
  
Risk Addressed:
Unauthorized spending beyond delegated authority thresholds.

Why It Matters:
Approval limit breaches indicate either:
	•	Weak enforcement of approval hierarchy
	•	Manual overrides without documentation
	•	Policy misalignment between transaction size and delegated authority

This control directly tests compliance with internal approval policies.
2. High-Value Transaction Monitoring

Control Logic:
Identify transactions exceeding predefined high-value thresholds.

Risk Addressed:
Material financial exposure and elevated fraud risk.

Why It Matters:
Large transactions inherently carry higher risk. Monitoring them allows audit teams to:
	•	Prioritize review
	•	Evaluate approval sufficiency
	•	Assess concentration of exposure

This supports risk-based audit planning.


3. Vendor Risk Concentration Analysis

Control Logic:
Aggregate breach amount and total spend by vendor to identify disproportionate exception patterns.

Risk Addressed:
Vendor dependency risk and potential control circumvention at vendor level.

Why It Matters:
Risk is often vendor-concentrated rather than department-driven.
A small number of vendors frequently account for a large share of breaches.

Vendor-level monitoring enables:
	•	Targeted vendor review
	•	Contract renegotiation assessment
	•	Fraud exposure analysis

⸻

4. Departmental Breach Rate Analysis

Control Logic:
Calculate breach rate by department:
    Breach Amount ÷ Total Spend
Risk Addressed:
Systemic control weaknesses within operational units.

Why It Matters:
This metric normalizes exposure relative to activity level, allowing:
	•	Cross-department risk comparison
	•	Identification of control maturity gaps
	•	Internal audit prioritization


5. Spending vs Approval Threshold Alignment

Control Logic:
Compare average transaction amount to average approval limit by department.

Risk Addressed:
Policy design risk and threshold miscalibration.

Why It Matters:
When average transaction size approaches approval limits:
	•	Override risk increases
	•	Policy compliance becomes harder to enforce
	•	Control effectiveness declines

This supports governance recalibration.


Monitoring Philosophy

The system is designed around a key principle:

Controls should be evaluated at the transaction level, aggregated for insight, and visualized for executive decision-making.

By integrating SQL-based control logic with Power BI risk visualization, the framework demonstrates how operational data can be transformed into continuous control monitoring infrastructure.
