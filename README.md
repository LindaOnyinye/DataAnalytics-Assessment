 SQL Assessment

 Overview

This project addresses key analytical needs of the business by writing optimized MySQL queries to extract customer insights from the adashi_staging database.


Questions & Approaches

 1. High-Value Customers with Multiple Products

Task: Identify customers with at least one funded savings plan and one funded investment plan, sorted by total deposits.

Approach:
- Used conditional aggregation to count the number of savings and investment plans.
- Filtered plans based on is_regular_savings and is_a_fund.
- Considered only deposits (confirmed_amount > 0).
- Aggregated deposits and sorted results by total_deposits.


 2. Transaction Frequency Analysis

Task: Segment customers by their monthly transaction frequency into High, Medium, or Low categories.

Approach:
- Calculated transactions per customer per month using DATE_FORMAT().
- Computed average transactions per customer.
- Used a CASE statement to categorize frequency.
- Final output grouped by category with average and count.

Note: Avoided CTEs for compatibility with MySQL versions below 8.0.


 3. Account Inactivity Alert

Task: Find active accounts with no deposit activity in the last 365 days.

Approach:
- Joined plans_plan with savings_savings account using a LEFT JOIN to retain inactive accounts.
- Used MAX(date_time) to find the last transaction date.
- Applied DATEDIFF() to compute inactivity duration.
- Filtered for inactivity using the HAVING clause.


 4. Customer Lifetime Value (CLV) Estimation

Task: Estimate CLV using the formula:  
CLV = (total_transactions / tenure_months)  12  avg_profit_per_transaction

Approach:
- Calculated tenure in months using TIMESTAMPDIFF().
- Counted transactions and averaged profit (0.1% of confirmed_amount).
- Handled division by zero using NULLIF().


 Challenges & Resolutions

 1. Alias Usage in GROUP BY
Issue: MySQL does not allow using column aliases (e.g.,year_month) in the same SELECT and GROUP BY.

Fix: Replaced aliases with full expressions like DATE_FORMAT(...) in GROUP BY.


 2. Division by Zero in Tenure
Issue: Some users had tenure of 0 months, causing division errors.

Fix: Used NULLIF(tenure, 0) to avoid division by zero.


 3. CTE Compatibility
Issue: MySQL <8.0 does not support CTEs.

Fix: Rewrote CTE queries as nested subqueries.


 4. Missing or Misnamed Fields
Issue: Errors from using incorrect field names like transaction_date.

Fix: Verified and updated field names to date_time and ensured they existed in the schema.


 Note: All monetary values are in kobo, converted to naira where applicable.
