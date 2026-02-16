-- =====================================
-- 04_churn_analysis.sql
-- Churn & Retention Analysis
-- =====================================


-- =====================================
-- 1. Churn Rate by Acquisition Channel
-- Purpose:
--   Identify which marketing channel
--   brings less stable customers.
-- =====================================

SELECT 
    u.acquisition_channel,
    COUNT(CASE WHEN s.status = 'Canceled' THEN 1 END) * 1.0 
        / COUNT(*) AS churn_rate
FROM subscriptions s
JOIN users u 
    ON s.user_id = u.user_id
GROUP BY u.acquisition_channel
ORDER BY churn_rate DESC;



-- =====================================
-- 2. Churn Rate by Plan
-- Purpose:
--   Determine which subscription tier
--   has the highest cancellation rate.
-- =====================================

SELECT 
    plan,
    COUNT(CASE WHEN status = 'Canceled' THEN 1 END) * 1.0
        / COUNT(*) AS churn_rate
FROM subscriptions
GROUP BY plan
ORDER BY churn_rate DESC;
