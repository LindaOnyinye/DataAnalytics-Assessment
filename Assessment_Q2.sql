-- Step 1: Calculate monthly transaction counts per customer
WITH transactions_per_month AS (
    SELECT
        s.owner_id,  -- Customer ID
        DATE_FORMAT(s.date_time, '%Y-%m') AS year_month,  -- Format date_time to Year-Month
        COUNT(*) AS transactions_count  -- Total number of transactions for this customer in this specific month
    FROM
        savings_savingsaccount s
    GROUP BY
        s.owner_id,
        year_month
),

-- Step 2: Calculate average transactions per month per customer
avg_transactions AS (
    SELECT
        owner_id,
        AVG(transactions_count) AS avg_tx_per_month  -- Average transactions monthly
    FROM
        transactions_per_month
    GROUP BY
        owner_id
),

-- Step 3: Categorize customers by average transaction frequency
categorized AS (
    SELECT
        owner_id,
        avg_tx_per_month,
        CASE
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM
        avg_transactions
)

-- Step 4: Aggregate results by category and show customer counts and average transactions
SELECT
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM
    categorized
GROUP BY
    frequency_category
ORDER BY
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
