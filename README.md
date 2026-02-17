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

## Analytical Workflow

1. Data Generation & Simulation (Python)
2. Data Modeling & KPI Engineering (SQL)
3. Revenue Segmentation & Growth Analysis
4. Churn & Lifetime Value Analysis
5. Cohort Retention Analysis
6. Dashboard Visualization


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
## 🤖 Predictive Churn Modeling

A Logistic Regression model was built to predict customer churn using engineered user-level features.

### Feature Engineering

- Payment count  
- Total revenue  
- Average payment amount  
- Active days  
- Total watch time  
- Average watch time per day  
- Subscription plan pricing  

### Model Performance

- Model: Logistic Regression  
- Evaluation Metric: ROC-AUC  
- Achieved ROC-AUC: **0.75**

An initial model achieved AUC = 1.0 due to data leakage caused by using post-churn subscription end dates.  
The leakage was removed to ensure realistic predictive evaluation.
## Technical Highlights

- PostgreSQL
- Common Table Expressions (CTEs)
- Window Functions
- Date Spine Generation
- Lifecycle Modeling
- Revenue Aggregation Logic
- SQL  
- Python (pandas, matplotlib, seaborn)  
- scikit-learn  
- Jupyter Notebook  
- Git & GitHub 


---

## Project Structure

```bash
subscription-analytics-sql/
│
├── Dashboard/
│   └── dashboard.py
│
├── Data/
│   ├── dataset_creation.py
│   ├── users.csv
│   ├── subscriptions.csv
│   ├── payments.csv
│   └── user_activity.csv
│
├── Notebooks/
│   └──churn_prediction.ipynb
│
├── Outputs/
│   └── dashboard.png
│
├── SQL/
│   ├── 00_schema.sql
│   ├── 01_exploration.sql
│   ├── 02_kpi_analysis.sql
│   ├── 03_revenue_breakdown.sql
│   ├── 04_churn_analysis.sql
│   ├── 05_ltv_analysis.sql
│   └── 06_cohort_analysis.sql
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
