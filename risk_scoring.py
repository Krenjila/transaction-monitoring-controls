# 03_risk_scoring.py
# Layer 1 — Risk Scoring Engine
# Assigns each control exception a severity of High, Medium, or Low
# based on exception type, dollar amount, and vendor country risk.

import csv

# ---------------------------------------------------------------------------
# Country risk tiers
# Based on your vendor list in generate_data.py:
#   US → Low   |   HK, KY, CN → High
# MEDIUM_RISK_COUNTRIES is empty for now — your simulated data has no
# developing-nation vendors, but the logic is ready to expand.
# ---------------------------------------------------------------------------
HIGH_RISK_COUNTRIES = ["CN", "KY", "HK"]
MEDIUM_RISK_COUNTRIES = []
# Anything not in the above two lists defaults to Low risk

# Used to compare severity labels as if they were numbers
SEVERITY_RANK = {"Low": 1, "Medium": 2, "High": 3}


def score_exception(exception_type, amount, approval_limit, vendor_country):
    """
    Scores a single exception as High, Medium, or Low severity.

    Parameters:
        exception_type  : str   — 'Approval Limit Breach',
                                   'Duplicate Invoice Payment',
                                   'Potential Split Payment'
        amount          : float — transaction amount
        approval_limit  : float — approver's spending limit
        vendor_country  : str   — 2-letter country code e.g. 'US', 'CN', 'KY'

    Returns:
        str — 'High', 'Medium', or 'Low'
    """

    # ------------------------------------------------------------------
    # Step 2 — Exception type base score
    # Your hierarchy: Control Breach > Duplicate Invoice > Split Payment
    # ------------------------------------------------------------------
    if exception_type == "Approval Limit Breach":
        type_score = "High"
    elif exception_type == "Duplicate Invoice Payment":
        type_score = "Medium"
    else:                                          # Potential Split Payment
        type_score = "Low"

    # ------------------------------------------------------------------
    # Step 3 — Amount score
    # For breaches:     use the overage (amount - approval_limit)
    # For everything else: use the raw transaction amount
    # Thresholds you designed: <2000 = Low, 2000–10000 = Medium, >10000 = High
    # ------------------------------------------------------------------
    if exception_type == "Approval Limit Breach":
        breach_amount = amount - approval_limit
    else:
        breach_amount = amount                     # raw dollar amount

    if breach_amount < 2000:
        amount_score = "Low"
    elif breach_amount < 10000:
        amount_score = "Medium"
    else:
        amount_score = "High"

    # ------------------------------------------------------------------
    # Step 4 — Country risk score
    # ------------------------------------------------------------------
    if vendor_country in HIGH_RISK_COUNTRIES:
        country_score = "High"
    elif vendor_country in MEDIUM_RISK_COUNTRIES:
        country_score = "Medium"
    else:
        country_score = "Low"

    # ------------------------------------------------------------------
    # Step 5 — Final score: highest of the three inputs wins
    # Then apply escalation rule: high-risk country floor is Medium
    # ------------------------------------------------------------------
    final_score = max(
        [type_score, amount_score, country_score],
        key=lambda s: SEVERITY_RANK[s]
    )

    # Escalation rule — if country is high risk, final score is never Low
    if country_score == "High" and final_score == "Low":
        final_score = "Medium"

    return final_score


# ---------------------------------------------------------------------------
# Run scoring against your transactions CSV and print results
# ---------------------------------------------------------------------------
if __name__ == "__main__":

    # Hardcoded exceptions pulled from what your SQL would flag.
    # In Layer 2 you will connect this directly to your PostgreSQL database.
    # For now we test on a small sample so you can verify the logic works.

    test_exceptions = [
        # (exception_type,              amount,   approval_limit, vendor_country)
        ("Approval Limit Breach",       12000.00, 5000.00,        "US"),  # expect High
        ("Approval Limit Breach",       5800.00,  5000.00,        "CN"),  # expect High (country bump)
        ("Approval Limit Breach",       1200.00,  1000.00,        "US"),  # expect High (type wins)
        ("Duplicate Invoice Payment",   500.00,   1000.00,        "US"),  # expect Medium (type wins)
        ("Duplicate Invoice Payment",   500.00,   1000.00,        "KY"),  # expect Medium (country bump)
        ("Potential Split Payment",     4800.00,  5000.00,        "US"),  # expect Medium (amount)
        ("Potential Split Payment",     4800.00,  5000.00,        "CN"),  # expect High (country)
        ("Potential Split Payment",     300.00,   5000.00,        "US"),  # expect Low
    ]

    print(f"{'Exception Type':<30} {'Amount':>10} {'Country':>8} {'Score':>8}")
    print("-" * 62)

    for exc_type, amt, lim, country in test_exceptions:
        score = score_exception(exc_type, amt, lim, country)
        print(f"{exc_type:<30} ${amt:>9,.2f} {country:>8} {score:>8}")
