# Subscription Revenue Analytics (SQL)

## Overview

This project models subscription-based revenue using SQL and lifecycle-aware logic.

It builds a time-based KPI engine to analyze:

- Monthly Recurring Revenue (MRR)
- Active Subscribers
- New & Churned MRR
- Net Revenue Growth
- Revenue by Acquisition Channel
- ARPU by Marketing Source

The goal of this project is to simulate how a SaaS analytics team would model subscription revenue for reporting and business decision-making.


---

## Dataset

The project uses three core tables:

- `users`
- `subscriptions`
- `payments`

The schema simulates a subscription-based digital product with different acquisition channels and pricing tiers.


---

## Key Features

### 1. Lifecycle-Aware Subscription Modeling
Subscriptions are expanded across active months using a generated date spine.

This ensures accurate MRR tracking over time.

### 2. KPI Engine

The KPI model calculates:

- MRR
- New MRR
- Churned MRR
- Net New MRR
- Month-over-Month Growth Rate

Window functions are used to compute revenue movement and growth trends.

### 3. Revenue Segmentation

Revenue is analyzed by:

- Acquisition channel
- Subscription plan
- Monthly ARPU by channel

This enables performance comparison across marketing sources.


---

## Technical Highlights

- PostgreSQL
- Common Table Expressions (CTEs)
- Window Functions
- Date Spine Generation
- Lifecycle Modeling
- Revenue Aggregation Logic


---

## Project Structure

subscription-analytics-sql/
│
├── data/
├── sql/
│ ├── 01_schema.sql
│ ├── 02_kpi_engine.sql
│ └── 03_revenue_breakdown.sql
│
└── README.md
---

## Why This Project

This project demonstrates:

- Strong SQL fundamentals
- Business metric modeling
- Understanding of SaaS revenue mechanics
- Clean query architecture
- Analytics-focused problem solving

It serves as a foundation for future predictive modeling and churn analysis workflows.
