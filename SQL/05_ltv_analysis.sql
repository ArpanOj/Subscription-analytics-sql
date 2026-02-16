-- =====================================
-- 05_ltv_analysis.sql
-- Customer Lifetime Value Estimation
-- =====================================


-- =====================================
-- 1. LTV by Acquisition Channel
-- Formula:
--   LTV ≈ ARPU / Churn Rate
-- =====================================

WITH arpu_table AS (
    SELECT 
        u.acquisition_channel,
        SUM(s.monthly_price) / COUNT(DISTINCT s.user_id) AS arpu
    FROM subscriptions s
    JOIN users u 
        ON s.user_id = u.user_id
    WHERE s.status = 'Active'
    GROUP BY u.acquisition_channel
),
churn_table AS (
    SELECT 
        u.acquisition_channel,
        COUNT(CASE WHEN s.status = 'Canceled' THEN 1 END) * 1.0
            / COUNT(*) AS churn_rate
    FROM subscriptions s
    JOIN users u 
        ON s.user_id = u.user_id
    GROUP BY u.acquisition_channel
)

SELECT 
    a.acquisition_channel,
    a.arpu,
    c.churn_rate,
    a.arpu / c.churn_rate AS estimated_ltv
FROM arpu_table a
JOIN churn_table c
    ON a.acquisition_channel = c.acquisition_channel
ORDER BY estimated_ltv DESC;
