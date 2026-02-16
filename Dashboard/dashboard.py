import psycopg2
import pandas as pd
import matplotlib.pyplot as plt

# -------------------------------------
# DATABASE CONNECTION
# -------------------------------------

conn = psycopg2.connect(
    host="localhost",
    database="Subscription Analytics",
    user="postgres",
    password="arpau_sql"
)

# -------------------------------------
# KPI QUERY
# -------------------------------------

kpi_query = """
SELECT
    SUM(p.amount) AS total_revenue,
    COUNT(DISTINCT s.user_id) FILTER (WHERE s.status = 'Active') AS active_users,
    COUNT(DISTINCT s.user_id) AS total_users
FROM subscriptions s
LEFT JOIN payments p ON s.user_id = p.user_id
WHERE p.payment_status IN ('Success', 'Recovered');
"""

kpi_df = pd.read_sql(kpi_query, conn)

total_revenue = kpi_df['total_revenue'][0] or 0
active_users = kpi_df['active_users'][0] or 0
total_users = kpi_df['total_users'][0] or 0

if total_users > 0:
    churn_rate = round((total_users - active_users) / total_users * 100, 2)
    arpu = round(total_revenue / total_users, 2)
else:
    churn_rate = 0
    arpu = 0

# -------------------------------------
# QUERIES
# -------------------------------------

# 1️⃣ Monthly Recurring Revenue (MRR)
revenue_query = """
WITH months AS (
    SELECT generate_series(
        (SELECT MIN(start_date) FROM subscriptions),
        CURRENT_DATE,
        INTERVAL '1 month'
    ) AS month
)

SELECT 
    DATE_TRUNC('month', m.month) AS month,
    SUM(s.monthly_price) AS mrr
FROM months m
JOIN subscriptions s
    ON s.start_date <= m.month
    AND (s.end_date IS NULL OR s.end_date > m.month)
GROUP BY month
ORDER BY month;
"""

# 2️⃣ Active Subscriptions
active_query = """
SELECT 
    DATE_TRUNC('month', start_date) AS month,
    COUNT(*) AS active_subscriptions
FROM subscriptions
WHERE status = 'Active'
GROUP BY month
ORDER BY month;
"""

# 3️⃣ Revenue by Channel
channel_query = """
SELECT 
    u.acquisition_channel,
    SUM(p.amount) AS revenue
FROM payments p
JOIN users u ON p.user_id = u.user_id
WHERE p.payment_status IN ('Success', 'Recovered')
GROUP BY u.acquisition_channel
ORDER BY revenue DESC;
"""

# 4️⃣ Retention Curve
retention_query = """
WITH user_cohorts AS (
    SELECT 
        user_id,
        DATE_TRUNC('month', signup_date) AS cohort_month
    FROM users
),
activity_months AS (
    SELECT 
        user_id,
        DATE_TRUNC('month', activity_date) AS activity_month
    FROM user_activity
)

SELECT 
    EXTRACT(YEAR FROM activity_month) * 12 
    + EXTRACT(MONTH FROM activity_month)
    - (EXTRACT(YEAR FROM cohort_month) * 12 
    + EXTRACT(MONTH FROM cohort_month)) 
    AS months_since_signup,
    COUNT(DISTINCT ua.user_id) AS active_users
FROM user_cohorts uc
JOIN activity_months ua
    ON uc.user_id = ua.user_id
WHERE activity_month >= cohort_month
GROUP BY months_since_signup
ORDER BY months_since_signup;
"""

# -------------------------------------
# LOAD DATA
# -------------------------------------

revenue_df = pd.read_sql(revenue_query, conn)
active_df = pd.read_sql(active_query, conn)
channel_df = pd.read_sql(channel_query, conn)
retention_df = pd.read_sql(retention_query, conn)

conn.close()

# -------------------------------------
# BUILD DASHBOARD
# -------------------------------------

fig, axes = plt.subplots(2, 2, figsize=(15, 10))

# 🔹 KPI HEADER
fig.suptitle(
    f"Revenue: {total_revenue/1e6:.2f}M   |   "
    f"Active Users: {active_users}   |   "
    f"Churn: {churn_rate}%   |   "
    f"ARPU: {arpu:.2f}",
    fontsize=14,
    fontweight="bold"
)


# 1️⃣ Revenue Trend
axes[0, 0].plot(revenue_df['month'], revenue_df['mrr'])
axes[0, 0].set_title("Monthly Recurring Revenue (MRR)")
axes[0, 0].tick_params(axis='x', rotation=45)

# 2️⃣ Active Subs
axes[0, 1].plot(active_df['month'], active_df['active_subscriptions'])
axes[0, 1].set_title("Active Subscriptions")
axes[0, 1].tick_params(axis='x', rotation=45)

# 3️⃣ Revenue by Channel
axes[1, 0].bar(channel_df['acquisition_channel'], channel_df['revenue'])
axes[1, 0].set_title("Revenue by Channel")
axes[1, 0].tick_params(axis='x', rotation=45)

# 4️⃣ Retention Curve
axes[1, 1].plot(retention_df['months_since_signup'], retention_df['active_users'])
axes[1, 1].set_title("Retention Curve")
axes[1, 1].set_xlabel("Months Since Signup")
axes[1, 1].set_ylabel("Active Users")

plt.tight_layout()
plt.subplots_adjust(top=0.90)

# Save the dashboard
plt.savefig("outputs/dashboard.png")

plt.show()
