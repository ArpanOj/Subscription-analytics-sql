# Subscription Revenue Analytics (SQL)

# Subscription Revenue Analytics & KPI Modeling (SQL)

## Project Overview

This project builds a lifecycle-aware revenue analytics engine for a subscription-based business using SQL.

The goal was to simulate how a SaaS analytics team models Monthly Recurring Revenue (MRR), churn, growth, and revenue segmentation for reporting and strategic decision-making.

The system expands subscriptions across active months using a generated date spine and calculates revenue movement using structured CTE pipelines and window functions.


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

```bash
subscription-analytics-sql/
│
├── data/
│
├── sql/
│   ├── 01_schema.sql
│   ├── 02_kpi_engine.sql
│   └── 03_revenue_breakdown.sql
│
└── README.md
```

---

## Why This Project

This project demonstrates:

- Strong SQL fundamentals
- Business metric modeling
- Understanding of SaaS revenue mechanics
- Clean query architecture
- Analytics-focused problem solving

It serves as a foundation for future predictive modeling and churn analysis workflows.

---

## What This Project Demonstrates

- Ability to model time-based subscription revenue
- Strong understanding of SaaS KPIs and growth mechanics
- Clean SQL architecture using layered CTEs
- Business-oriented metric design
- Readiness for analytics and data-focused roles

This project serves as a foundation for future work in churn prediction, cohort analysis, and machine learning-based revenue forecasting.
