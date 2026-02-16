-- =====================================
-- 00_schema.sql
-- Database Schema Definition
-- =====================================

-- Drop tables if they exist (for reproducibility)
DROP TABLE IF EXISTS user_activity;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    age INT,
    country VARCHAR(50),
    device VARCHAR(50),
    acquisition_channel VARCHAR(50),
    signup_date DATE
);

CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY,
    user_id INT,
    plan VARCHAR(50),
    monthly_price DECIMAL(10,2),
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    user_id INT,
    subscription_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

CREATE TABLE user_activity (
    activity_id SERIAL PRIMARY KEY,
    user_id INT,
    activity_date DATE,
    watch_time_minutes DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);