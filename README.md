# Credit Risk Analysis and Default Prediction

Predicting which credit card borrowers are likely to default, using Python, SQL, and Tableau.

https://public.tableau.com/app/profile/iyma.asif/viz/CreditRiskDashboard_17955760272250/Dashboard3?publish=yes


## Problem

Banks need to know how likely a borrower is to default and how much they could lose if they do. Credit risk models are built around three measures:

- **Probability of Default (PD):** how likely a borrower is to default.
- **Loss Given Default (LGD):** the share of the outstanding amount the bank loses if a default happens.
- **Exposure at Default (EAD):** the amount owed at the time of default.

Together they give the expected loss on a loan:

> **Expected Loss = PD x LGD x EAD**

This project builds an introductory credit risk workflow: explore the data, predict PD with machine learning, validate the models, query the results with SQL, and communicate the findings in a dashboard.

## Data

[UCI "Default of Credit Card Clients" dataset](https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients) (about 30,000 credit card clients in Taiwan, 2005). Each row is one borrower with:

- Credit limit, age, education, and marital status
- Repayment status for the past 6 months (how many months late)
- Bill amounts and payment amounts for the past 6 months
- Whether the borrower defaulted the following month (the target variable)

## Method

1. **Cleaning:** renamed columns (`default.payment.next.month` to `default`, `PAY_0` to `PAY_1`), dropped the ID column, removed duplicate rows, and grouped undocumented education codes (0, 5, 6) into "Other" and marriage code 0 into "Other".
2. **Exploratory analysis:** compared default rates across repayment status, credit limit, age, and education.
3. **Modeling:** trained Logistic Regression and Random Forest classifiers on 80% of the data and tested them on a held-out 20%, using a stratified split so both sets keep the same default rate.
4. **Validation:** accuracy, precision, recall, confusion matrices, ROC-AUC, and 5-fold cross-validation.
5. **SQL:** loaded the cleaned data into SQLite and wrote queries (in [`queries.sql`](queries.sql)) to calculate default rates by segment, find high-risk groups, and summarize portfolio performance.
6. **Expected loss:** used the Random Forest's predicted PD, with LGD and EAD set by simple assumptions (see Limitations), to calculate expected loss and assign each borrower to a Low, Medium, or High risk band.
7. **Dashboard:** built an interactive Tableau dashboard on the scored test set.


**Key findings**

- **The model separates risky borrowers from safe ones.** On the 5,993 test borrowers, actual default rates were **11.5%** in the Low risk band, **26.5%** in the Medium band, and **62.6%** in the High band.
- The overall default rate in the test set was **22.1%**.
- **Accuracy alone is misleading here.** About 78% of borrowers do not default, so a model that always predicts "no default" would be about 78% accurate while catching no defaulters. That is why I focused on recall, the confusion matrix, and ROC-AUC.
- **Expected loss by band:** the Low band has more total expected loss than the Medium band even though its borrowers are individually safer. It contains far more borrowers (3,610 vs. 1,611), so many small risks add up. 

## Dashboard

The Tableau dashboard shows the overall default rate, total borrowers, borrowers by risk band, actual default rate by risk band, expected loss by risk band, and default rate by age group.

https://public.tableau.com/app/profile/iyma.asif/viz/CreditRiskDashboard_17955760272250/Dashboard3?publish=yes


## Limitations

- **LGD and EAD are simplified assumptions.** The dataset has no recovery or loss information, so I assumed LGD = 45% and set EAD to the latest bill amount. The expected loss figures illustrate the framework and are not real loss estimates.
- **One country, one time period.** The data comes from Taiwan, and results may not generalize elsewhere.
- **No dates.** Each borrower appears once, so I could not analyze trends over calendar time. Month-to-month comparisons use the 6 monthly columns instead.
- **Introductory model.** I used default settings with limited tuning, and I did not test for fairness, calibration, or stability, all of which matter in a real bank.
- **Scored on the test set only.** The dashboard uses the 20% of borrowers the model had not seen, not the full dataset.


## Files

| File | Description |
|---|---|
| `credit_risk_analysis.ipynb` | Full analysis: cleaning, EDA, modeling, validation, SQL, and scoring |
| `queries.sql` | SQL queries used to analyze default rates and risk segments |
| `credit_risk_scored.csv` | Scored test set (PD, EAD, expected loss, risk band) used in Tableau |
| `dashboard_screenshot.png` | Screenshot of the Tableau dashboard |

## Tools

Python (pandas, NumPy, scikit-learn, Matplotlib, Seaborn), SQL (SQLite), Tableau Public, Google Colab.
