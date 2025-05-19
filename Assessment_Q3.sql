-- Find all active accounts with no inflow transactions in the last 365 days

SELECT
    p.id AS plan_id,  -- Unique identifier for the plan
    p.owner_id,       -- ID of the customer who owns the plan
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'      -- Mark as Savings if it's a regular savings plan
        WHEN p.is_a_fund = 1 THEN 'Investment'            -- Mark as Investment if it's a fund
        ELSE 'Other'                                      -- Fallback label if neither
    END AS type,
    MAX(s.date_time) AS last_transaction_date,            -- Most recent inflow transaction date for the plan
    DATEDIFF(CURDATE(), MAX(s.date_time)) AS inactivity_days  -- Days since the last inflow transaction
FROM
    plans_plan p
LEFT JOIN
    savings_savingsaccount s 
    ON s.plan_id = p.id 
    AND s.confirmed_amount > 0  -- Only consider inflow transactions (deposits)
WHERE
    p.is_active = 1  -- Consider only active plans
GROUP BY
    p.id, 
    p.owner_id, 
    type
HAVING
    MAX(s.date_time) IS NULL         -- No inflow ever recorded
    OR DATEDIFF(CURDATE(), MAX(s.date_time)) > 365  -- OR last inflow was more than 1 year ago
ORDER BY
    inactivity_days DESC;  -- Show most inactive accounts first
