-- ============================================================
-- 03_revenue_breakdown.sql
-- Revenue Segmentation & Monetization Analysis
-- ============================================================
-- Analyzes collected revenue by:
--   - Acquisition Channel
--   - Subscription Plan
--   - Monthly ARPU by Channel
-- ============================================================



-- ============================================================
-- 1. Revenue by Acquisition Channel
-- Aggregates successfully collected revenue
-- to evaluate marketing channel performance.
-- ============================================================

SELECT 
    u.acquisition_channel,
    SUM(p.amount) AS total_revenue
FROM payments p
JOIN users u 
    ON p.user_id = u.user_id
WHERE p.payment_status IN ('Success', 'Recovered')
GROUP BY u.acquisition_channel
ORDER BY total_revenue DESC;



-- ============================================================
-- 2. Revenue by Subscription Plan
-- Measures total collected revenue contribution
-- by pricing tier.
-- ============================================================

SELECT 
    s.plan,
    SUM(p.amount) AS total_revenue
FROM payments p
JOIN subscriptions s 
    ON p.subscription_id = s.subscription_id
WHERE p.payment_status IN ('Success', 'Recovered')
GROUP BY s.plan
ORDER BY total_revenue DESC;



-- ============================================================
-- 3. Monthly ARPU by Acquisition Channel
-- Expands subscriptions across active months
-- to calculate:
--   - Channel MRR
--   - Active Users
--   - ARPU (MRR / Active Users)
-- ============================================================

WITH date_spine AS (
    -- Generate monthly date spine for lifecycle tracking
    SELECT generate_series(
        DATE '2022-01-01',
        DATE '2025-12-01',
        INTERVAL '1 month'
    )::date AS month_start
),

active_subscriptions AS (
    -- Expand subscriptions across all active months
    SELECT
        d.month_start,
        s.user_id,
        s.monthly_price,
        u.acquisition_channel
    FROM date_spine d
    JOIN subscriptions s
        ON s.start_date <= (d.month_start + INTERVAL '1 month' - INTERVAL '1 day')
        AND (s.end_date IS NULL OR s.end_date >= d.month_start)
    JOIN users u
        ON s.user_id = u.user_id
)

SELECT
    month_start,
    acquisition_channel,
    SUM(monthly_price) AS channel_mrr,
    COUNT(DISTINCT user_id) AS active_users,
    SUM(monthly_price) 
        / NULLIF(COUNT(DISTINCT user_id), 0) AS arpu
FROM active_subscriptions
GROUP BY month_start, acquisition_channel
ORDER BY month_start, arpu DESC;
