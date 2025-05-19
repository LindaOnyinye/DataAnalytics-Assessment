-- Query to find customers with at least one funded savings plan AND one funded investment plan
-- Summarizes savings_count, investment_count, and total deposits in naira

SELECT 
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.id END) AS investment_count,
    SUM(s.confirmed_amount - s.amount_withdrawn) / 100.0 AS total_deposits  -- convert kobo to naira
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
JOIN 
    plans_plan p ON s.plan_id = p.id
WHERE
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    AND (s.confirmed_amount - s.amount_withdrawn) > 0  -- funded condition
GROUP BY
    u.id, u.name
HAVING
    savings_count > 0
    AND investment_count > 0
ORDER BY
    total_deposits DESC;
