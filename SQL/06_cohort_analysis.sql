-- =====================================
-- 06_cohort_analysis.sql
-- Cohort Retention Analysis
-- =====================================


-- =====================================
-- 1. Assign Users to Signup Cohort
-- Purpose:
--   Group users by the month they signed up
-- =====================================

WITH user_cohorts AS (
    SELECT 
        user_id,
        DATE_TRUNC('month', signup_date) AS cohort_month
    FROM users
)

SELECT *
FROM user_cohorts
LIMIT 10;

-- =====================================
-- 2. Cohort Size (Users per Month)
-- =====================================

SELECT 
    DATE_TRUNC('month', signup_date) AS cohort_month,
    COUNT(*) AS cohort_size
FROM users
GROUP BY cohort_month
ORDER BY cohort_month;

-- =====================================
-- 3. Active Users per Cohort
-- Purpose:
--   Measure how many users in each cohort
--   currently have an Active subscription.
-- =====================================

WITH user_cohorts AS (
    SELECT 
        u.user_id,
        DATE_TRUNC('month', u.signup_date) AS cohort_month
    FROM users u
)

SELECT 
    uc.cohort_month,
    COUNT(DISTINCT uc.user_id) AS cohort_size,
    COUNT(DISTINCT CASE 
        WHEN s.status = 'Active' THEN uc.user_id 
    END) AS active_users,
    
    COUNT(DISTINCT CASE 
        WHEN s.status = 'Active' THEN uc.user_id 
    END) * 1.0 / COUNT(DISTINCT uc.user_id) AS retention_rate

FROM user_cohorts uc
LEFT JOIN subscriptions s 
    ON uc.user_id = s.user_id
GROUP BY uc.cohort_month
ORDER BY uc.cohort_month;

-- =====================================
-- 4. True Monthly Retention Curve
-- =====================================

WITH user_cohorts AS (
    SELECT 
        u.user_id,
        DATE_TRUNC('month', u.signup_date) AS cohort_month
    FROM users u
),

cohort_sizes AS (
    SELECT 
        DATE_TRUNC('month', signup_date) AS cohort_month,
        COUNT(*) AS cohort_size
    FROM users
    GROUP BY cohort_month
),

activity_months AS (
    SELECT 
        ua.user_id,
        DATE_TRUNC('month', ua.activity_date) AS activity_month
    FROM user_activity ua
),

cohort_activity AS (
    SELECT 
        uc.cohort_month,
        am.activity_month,
        EXTRACT(YEAR FROM am.activity_month) * 12 
            + EXTRACT(MONTH FROM am.activity_month)
        - (EXTRACT(YEAR FROM uc.cohort_month) * 12 
            + EXTRACT(MONTH FROM uc.cohort_month)) 
        AS months_since_signup,
        am.user_id
    FROM user_cohorts uc
    JOIN activity_months am
        ON uc.user_id = am.user_id
)

SELECT 
    ca.cohort_month,
    ca.months_since_signup,
    COUNT(DISTINCT ca.user_id) * 1.0 / cs.cohort_size AS retention_rate
FROM cohort_activity ca
JOIN cohort_sizes cs
    ON ca.cohort_month = cs.cohort_month
GROUP BY ca.cohort_month, ca.months_since_signup, cs.cohort_size
ORDER BY ca.cohort_month, ca.months_since_signup;


