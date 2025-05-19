SELECT
    u.id AS customer_id,  -- Unique customer ID
    u.name,               -- Customer name
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,  -- Months since signup
    COUNT(s.id) AS total_transactions,  -- Total number of transactions
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) * 12 * AVG(s.confirmed_amount * 0.001) / 100,
        2
    ) AS estimated_clv  -- Estimated CLV using simplified formula
FROM
    users_customuser u
JOIN
    savings_savingsaccount s ON s.owner_id = u.id
WHERE
    s.confirmed_amount > 0  -- Only count inflow transactions
GROUP BY
    u.id, u.name, u.date_joined
ORDER BY
    estimated_clv DESC;
