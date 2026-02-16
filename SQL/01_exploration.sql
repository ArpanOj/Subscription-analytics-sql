-- =====================================
-- 01_exploration.sql
-- Initial Data Exploration
-- =====================================

-- Row counts
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM subscriptions;
SELECT COUNT(*) FROM payments;
SELECT COUNT(*) FROM user_activity;

-- Subscription status breakdown
SELECT status, COUNT(*)
FROM subscriptions
GROUP BY status;

-- Payment status breakdown
SELECT payment_status, COUNT(*)
FROM payments
GROUP BY payment_status;

-- Users by acquisition channel
SELECT acquisition_channel, COUNT(*)
FROM users
GROUP BY acquisition_channel
ORDER BY COUNT(*) DESC;
