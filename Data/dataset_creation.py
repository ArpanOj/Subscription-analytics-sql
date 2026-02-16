import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

np.random.seed(42)
random.seed(42)

# -----------------------
# 1. CONFIGURATION
# -----------------------
NUM_USERS = 3000   # Reduced for performance
START_DATE = datetime(2023, 1, 1)
END_DATE = datetime(2024, 12, 31)

subscription_plans = {
    "Basic": 9.99,
    "Standard": 14.99,
    "Premium": 19.99
}

countries = ["Thailand", "Singapore", "USA", "UK", "Germany", "India", "Australia"]
devices = ["Mobile", "Desktop", "Tablet"]
acquisition_channels = ["Organic", "Google Ads", "Facebook Ads", "Referral", "Affiliate"]

# -----------------------
# 2. USERS TABLE
# -----------------------
users = []

for user_id in range(1, NUM_USERS + 1):
    signup_date = START_DATE + timedelta(days=random.randint(0, 365))

    users.append([
        user_id,
        random.randint(18, 60),
        random.choice(countries),
        random.choice(devices),
        random.choice(acquisition_channels),
        signup_date
    ])

users_df = pd.DataFrame(users, columns=[
    "user_id", "age", "country", "device",
    "acquisition_channel", "signup_date"
])

signup_dict = users_df.set_index("user_id")["signup_date"].to_dict()

# -----------------------
# 3. SUBSCRIPTIONS TABLE
# -----------------------
subscriptions = []
subscription_id = 1

for user_id in users_df["user_id"]:

    start_date = signup_dict[user_id]
    current_plan = random.choice(list(subscription_plans.keys()))
    active = True

    while active and start_date < END_DATE:

        churn_chance = np.random.rand()

        if churn_chance < 0.25:
            end_date = start_date + timedelta(days=random.randint(60, 365))
            status = "Canceled"
            active = False
        else:
            end_date = None
            status = "Active"

        subscriptions.append([
            subscription_id,
            user_id,
            current_plan,
            subscription_plans[current_plan],
            start_date,
            end_date,
            status
        ])

        subscription_id += 1

        if active:
            # possible plan change every 6 months
            if random.random() < 0.2:
                current_plan = random.choice(list(subscription_plans.keys()))

            start_date += timedelta(days=180)

subscriptions_df = pd.DataFrame(subscriptions, columns=[
    "subscription_id", "user_id", "plan",
    "monthly_price", "start_date", "end_date", "status"
])

# -----------------------
# 4. PAYMENTS TABLE
# -----------------------
payments = []
payment_id = 1

for _, row in subscriptions_df.iterrows():

    billing_date = pd.to_datetime(row["start_date"])

    if pd.isnull(row["end_date"]):
        last_date = END_DATE
    else:
        last_date = pd.to_datetime(row["end_date"])

    while billing_date <= last_date:

        payment_status = "Success"

        # 8% failure rate
        if random.random() < 0.08:
            payment_status = "Failed"

            # 50% recovery chance
            if random.random() < 0.5:
                payments.append([
                    payment_id,
                    row["user_id"],
                    row["subscription_id"],
                    row["monthly_price"],
                    billing_date + timedelta(days=3),
                    "Recovered"
                ])
                payment_id += 1

        payments.append([
            payment_id,
            row["user_id"],
            row["subscription_id"],
            row["monthly_price"],
            billing_date,
            payment_status
        ])

        payment_id += 1
        billing_date += timedelta(days=30)

payments_df = pd.DataFrame(payments, columns=[
    "payment_id", "user_id", "subscription_id",
    "amount", "payment_date", "payment_status"
])

# -----------------------
# 5. USER ACTIVITY TABLE
# -----------------------
activity = []

for user_id in users_df["user_id"]:
    for _ in range(random.randint(20, 120)):   # Reduced activity range
        activity_date = START_DATE + timedelta(days=random.randint(0, 730))
        watch_time = np.random.exponential(scale=35)

        activity.append([
            user_id,
            activity_date,
            round(watch_time, 2)
        ])

activity_df = pd.DataFrame(activity, columns=[
    "user_id", "activity_date", "watch_time_minutes"
])

# -----------------------
# 6. SAVE DATASETS
# -----------------------
print("Saving users...")
users_df.to_csv("users.csv", index=False)

print("Saving subscriptions...")
subscriptions_df.to_csv("subscriptions.csv", index=False)

print("Saving payments...")
payments_df.to_csv("payments.csv", index=False)

print("Saving activity...")
activity_df.to_csv("user_activity.csv", index=False)

print("✅ Dataset successfully generated!")
print("Users:", len(users_df))
print("Subscriptions:", len(subscriptions_df))
print("Payments:", len(payments_df))
print("Activity:", len(activity_df))
