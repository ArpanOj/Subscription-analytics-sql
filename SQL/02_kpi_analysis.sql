-- =====================================
-- 02_kpi_analysis.sql
-- Core SaaS Financial KPI Model
-- =====================================
--
-- This model calculates time-based subscription metrics
-- using lifecycle-aware logic.
--
-- Metrics included:
--   • Monthly Recurring Revenue (MRR)
--   • Active Users
--   • New MRR
--   • Churned MRR
--   • Net New MRR
--   • MRR Growth Rate
--
-- Approach:
--   1. Generate monthly date spine
--   2. Model active subscriptions by month
--   3. Aggregate revenue metrics
--   4. Apply window functions for growth
-- =====================================


-- Generate monthly calendar
WITH date_spine AS (
    SELECT generate_series(
        DATE '2022-01-01',
        DATE '2025-12-01',
        INTERVAL '1 month'
    )::date AS month_start
),

-- Identify active subscriptions per month
-- A subscription is active if:
--   start_date <= month_end
--   AND (end_date IS NULL OR end_date >= month_start)
active_subscriptions AS (
    SELECT
        d.month_start,
        s.subscription_id,
        s.user_id,
        s.monthly_price
    FROM date_spine d
    JOIN subscriptions s
        ON s.start_date <= (d.month_start + INTERVAL '1 month' - INTERVAL '1 day')
        AND (s.end_date IS NULL OR s.end_date >= d.month_start)
),

-- Aggregate core monthly metrics
monthly_metrics AS (
    SELECT
        month_start,
        SUM(monthly_price) AS mrr,
        COUNT(DISTINCT user_id) AS active_users
    FROM active_subscriptions
    GROUP BY month_start
),

-- Revenue from newly started subscriptions
new_mrr AS (
    SELECT
        DATE_TRUNC('month', start_date) AS month_start,
        SUM(monthly_price) AS new_mrr
    FROM subscriptions
    GROUP BY 1
),

-- Revenue lost from churned subscriptions
churn_mrr AS (
    SELECT
        DATE_TRUNC('month', end_date) AS month_start,
        SUM(monthly_price) AS churned_mrr
    FROM subscriptions
    WHERE end_date IS NOT NULL
    GROUP BY 1
),

-- Combine revenue movement metrics
combined_metrics AS (
    SELECT
        m.month_start,
        m.mrr,
        m.active_users,
        COALESCE(n.new_mrr, 0) AS new_mrr,
        COALESCE(c.churned_mrr, 0) AS churned_mrr,
        COALESCE(n.new_mrr, 0) - COALESCE(c.churned_mrr, 0) AS net_new_mrr
    FROM monthly_metrics m
    LEFT JOIN new_mrr n
        ON m.month_start = n.month_start
    LEFT JOIN churn_mrr c
        ON m.month_start = c.month_start
)

-- Final KPI output with growth calculation
SELECT
    month_start,
    mrr,
    active_users,
    new_mrr,
    churned_mrr,
    net_new_mrr,
    LAG(mrr) OVER (ORDER BY month_start) AS previous_mrr,
    (mrr - LAG(mrr) OVER (ORDER BY month_start))
        / NULLIF(LAG(mrr) OVER (ORDER BY month_start), 0) AS mrr_growth_rate
FROM combined_metrics
ORDER BY month_start;
