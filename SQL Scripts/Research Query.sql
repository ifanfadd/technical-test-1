-- ======================================================
-- RELATIONSHIP BETWEEN DEMOGRAPHIC CHARACTERISTICS AND TRANSACTION ERRORS
-- ======================================================

-- 1. Do certain age groups experience more transaction errors?
SELECT 
    g.age_group,
    COALESCE(SUM(CASE WHEN TRIM(t.errors) <> '' THEN 1 ELSE 0 END), 0) AS total_errors
FROM (
    SELECT 'Under 30' AS age_group
    UNION ALL SELECT '30-50'
    UNION ALL SELECT 'Above 50'
) g
LEFT JOIN users_data_staging u
    ON (CASE 
            WHEN u.current_age < 30 THEN 'Under 30'
            WHEN u.current_age BETWEEN 30 AND 50 THEN '30-50'
            ELSE 'Above 50'
        END) = g.age_group
LEFT JOIN transactions_data_staging t 
    ON t.client_id = u.id
GROUP BY g.age_group
ORDER BY total_errors DESC;

-- 2. Does gender affect the frequency of transaction errors?
SELECT 
    u.gender,
    COUNT(t.id) AS total_errors,
    COUNT(t.id) / COUNT(DISTINCT u.id) AS avg_errors_per_user
FROM users_data_staging u
JOIN transactions_data_staging t
    ON u.id = t.client_id
WHERE t.errors IS NOT NULL 
  AND TRIM(t.errors) <> ''
GROUP BY u.gender
ORDER BY total_errors DESC;

-- 3. How does credit score correlate with transaction errors?
SELECT 
    CASE 
        WHEN u.credit_score < 600 THEN 'Low'
        WHEN u.credit_score BETWEEN 600 AND 750 THEN 'Medium'
        ELSE 'High'
    END AS credit_group,
    COUNT(t.id) AS total_errors,
    COUNT(t.id) / COUNT(DISTINCT u.id) AS avg_errors_per_user
FROM users_data_staging u
JOIN transactions_data_staging t
    ON u.id = t.client_id
WHERE t.errors IS NOT NULL 
  AND TRIM(t.errors) <> ''
GROUP BY credit_group
ORDER BY total_errors DESC;

-- 4. Does yearly income affect transaction errors?
SELECT 
    CASE 
        WHEN u.yearly_income < 100000 THEN 'Low Yearly Income'
        WHEN u.yearly_income BETWEEN 100000 AND 200000 THEN 'Middle Yearly Income'
        ELSE 'High Yearly Income'
    END AS income_group,
    COUNT(DISTINCT u.id) AS total_users,
    COUNT(t.id) AS total_errors,
    COUNT(t.id) / COUNT(DISTINCT u.id) AS avg_errors_per_user
FROM users_data_staging u
LEFT JOIN transactions_data_staging t
    ON u.id = t.client_id
WHERE t.errors IS NOT NULL
  AND TRIM(t.errors) <> ''
GROUP BY income_group
ORDER BY 
    CASE 
        WHEN income_group = 'Low Yearly Income' THEN 1
        WHEN income_group = 'Middle Yearly Income' THEN 2
        ELSE 3
    END;

-- 5. How does Total Debt affect transaction errors?
SELECT 
    CASE 
        WHEN u.total_debt < 15000 THEN 'Low Debt (<15k)'
        WHEN u.total_debt BETWEEN 15000 AND 35000 THEN 'Medium Debt (15k-35k)'
        ELSE 'High Debt (>35k)'
    END AS debt_group,
    COUNT(DISTINCT u.id) AS total_users,
    COUNT(t.id) AS total_errors,
    COUNT(t.id) / COUNT(DISTINCT u.id) AS avg_errors_per_user
FROM users_data_staging u
LEFT JOIN transactions_data_staging t
    ON u.id = t.client_id
WHERE t.errors IS NOT NULL
  AND TRIM(t.errors) <> ''
GROUP BY debt_group
ORDER BY total_errors DESC;