import random
from datetime import date, timedelta
import csv

random.seed(42)

# ---- Config ----
N_TRANSACTIONS = 1200
START_DATE = date(2025, 1, 1)
DAYS = 180  # ~6 months

DEPARTMENTS = ["Finance", "Operations", "IT", "HR", "Sales", "Marketing"]
PAYMENT_METHODS = ["ACH", "Wire", "Check", "Card"]

# Vendor catalog (some normal, some "riskier" sounding)
VENDORS = [
    (101, "Amazon Business", "US"),
    (102, "Staples", "US"),
    (103, "Office Depot", "US"),
    (104, "Dell", "US"),
    (105, "Microsoft", "US"),
    (106, "FedEx", "US"),
    (107, "UPS", "US"),
    (108, "QuickFix Consulting", "US"),
    (109, "PrimeSource LLC", "US"),
    (110, "Global Supplies HK", "HK"),
    (111, "Oceanic Trading", "KY"),
    (112, "Unknown Vendor", "CN"),
]

APPROVERS = [
    ("A100", 1000),
    ("A200", 2500),
    ("A300", 5000),
    ("A400", 10000),
]

def rand_date():
    return START_DATE + timedelta(days=random.randint(0, DAYS))

def weighted_amount():
    # Mostly small/medium, some large outliers
    r = random.random()
    if r < 0.80:
        return round(random.uniform(20, 900), 2)
    elif r < 0.95:
        return round(random.uniform(900, 5000), 2)
    else:
        return round(random.uniform(5000, 25000), 2)

def make_invoice_id(vendor_id, i):
    return f"INV-{vendor_id}-{10000+i}"

rows = []
for i in range(1, N_TRANSACTIONS + 1):
    vendor_id, vendor_name, vendor_country = random.choice(VENDORS)
    dept = random.choice(DEPARTMENTS)
    method = random.choice(PAYMENT_METHODS)

    approver_id, approval_limit = random.choice(APPROVERS)
    amount = weighted_amount()
    t_date = rand_date()

    invoice_id = make_invoice_id(vendor_id, i)

    rows.append({
        "transaction_id": i,
        "transaction_date": t_date.isoformat(),
        "amount": amount,
        "vendor_id": vendor_id,
        "vendor_name": vendor_name,
        "vendor_country": vendor_country,
        "department": dept,
        "invoice_id": invoice_id,
        "payment_method": method,
        "approver_id": approver_id,
        "approval_limit": approval_limit
    })

# ---- Inject a few intentional control issues ----

# 1) Duplicate payment: copy an existing row but change transaction_id + date slightly
for k in range(10):
    base = random.choice(rows)
    dup = base.copy()
    dup["transaction_id"] = len(rows) + 1
    dup["transaction_date"] = (date.fromisoformat(base["transaction_date"]) + timedelta(days=random.randint(0,2))).isoformat()
    # keep invoice_id same to look like duplicate invoice payment
    rows.append(dup)

# 2) Approval threshold breaches: force amount above approval_limit
for k in range(15):
    r = random.choice(rows)
    r["amount"] = float(r["approval_limit"]) + round(random.uniform(100, 5000), 2)

# 3) Split payments: same vendor + same day with amounts that sum above 10k
split_vendor = random.choice(VENDORS)
split_date = rand_date().isoformat()
split_dept = random.choice(DEPARTMENTS)
for amt in [4800.00, 4700.00, 1200.00]:  # totals 10,700
    rows.append({
        "transaction_id": len(rows) + 1,
        "transaction_date": split_date,
        "amount": amt,
        "vendor_id": split_vendor[0],
        "vendor_name": split_vendor[1],
        "vendor_country": split_vendor[2],
        "department": split_dept,
        "invoice_id": f"SPLIT-{split_vendor[0]}-{random.randint(1000,9999)}",
        "payment_method": random.choice(PAYMENT_METHODS),
        "approver_id": "A300",
        "approval_limit": 5000
    })

# ---- Write CSV ----
out_path = "../data/transactions.csv"
fieldnames = list(rows[0].keys())

with open(out_path, "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=fieldnames)
    w.writeheader()
    w.writerows(rows)

print(f"Generated {len(rows)} transactions → {out_path}")
