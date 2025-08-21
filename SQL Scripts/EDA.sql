-- ======================================================
-- INSIGHT GENERAL
-- ======================================================

-- 1. Age Distribution
SELECT 
    CASE 
        WHEN current_age < 30 THEN 'Under 30'
        WHEN current_age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Above 50'
    END AS age_group,
    COUNT(*) AS total_users
FROM users_data_staging
GROUP BY age_group
ORDER BY total_users DESC;

-- 2. Gender Distribution
SELECT 
    gender, 
    COUNT(*) AS total_users
FROM users_data_staging
GROUP BY gender
ORDER BY gender;

-- 3. Age & Gender Distribution
SELECT 
    CASE 
        WHEN current_age < 30 THEN 'Under 30'
        WHEN current_age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Above 50'
    END AS age_group,
    gender,
    COUNT(*) AS total_users
FROM users_data_staging
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. Average Income & Debt by Age Group
SELECT 
    CASE 
        WHEN current_age < 30 THEN 'Under 30'
        WHEN current_age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Above 50'
    END AS age_group,
    COUNT(*) AS total_users,
    AVG(yearly_income) AS avg_yearly_income,
    AVG(per_capita_income) AS avg_per_capita_income,
    AVG(total_debt) AS avg_total_debt
FROM users_data_staging
GROUP BY age_group
ORDER BY age_group;

-- 5. Average Income & Debt by Gender
SELECT 
    gender,
    COUNT(*) AS total_users,
    AVG(yearly_income) AS avg_yearly_income,
    AVG(per_capita_income) AS avg_per_capita_income,
    AVG(total_debt) AS avg_total_debt
FROM users_data_staging
GROUP BY gender
ORDER BY gender;

-- 6. Credit Score Distribution
SELECT 
    CASE 
        WHEN credit_score < 600 THEN 'Low'
        WHEN credit_score BETWEEN 600 AND 750 THEN 'Medium'
        ELSE 'High'
    END AS credit_group,
    COUNT(*) AS total_users
FROM users_data_staging
GROUP BY credit_group
ORDER BY total_users DESC;

-- 7. Yearly Income Range
SELECT 
    MIN(yearly_income) AS min_yearly_income,
    MAX(yearly_income) AS max_yearly_income
FROM users_data_staging;

-- 8. Yearly Income Grouping
SELECT 
    CASE 
        WHEN yearly_income < 100000 THEN 'Low Yearly Income'
        WHEN yearly_income BETWEEN 100000 AND 200000 THEN 'Middle Yearly Income'
        ELSE 'High Yearly Income'
    END AS income_group,
    COUNT(*) AS total_users,
    AVG(yearly_income) AS avg_yearly_income
FROM users_data_staging
GROUP BY income_group
ORDER BY income_group;

-- 9. Total Debt Range
SELECT 
    MIN(total_debt) AS min_total_debt,
    MAX(total_debt) AS max_total_debt,
    AVG(total_debt) AS avg_total_debt,
    COUNT(*) AS total_users
FROM users_data_staging;

-- 10. Total Debt Grouping
SELECT 
    CASE 
        WHEN total_debt < 15000 THEN 'Low Debt (<15k)'
        WHEN total_debt BETWEEN 15000 AND 35000 THEN 'Medium Debt (15k-35k)'
        ELSE 'High Debt (>35k)'
    END AS debt_group,
    COUNT(*) AS total_users,
    MIN(total_debt) AS min_total_debt,
    MAX(total_debt) AS max_total_debt,
    AVG(total_debt) AS avg_total_debt
FROM users_data_staging
GROUP BY debt_group
ORDER BY 
    CASE 
        WHEN debt_group LIKE 'Low Debt%' THEN 1
        WHEN debt_group LIKE 'Medium Debt%' THEN 2
        ELSE 3
    END;

-- 11. Error Distribution in Transactions
SELECT 
    TRIM(errors) AS errors,
    COUNT(*) AS total_rows
FROM transactions_data_staging
WHERE TRIM(errors) <> ''
GROUP BY TRIM(errors)
ORDER BY total_rows DESC;

-- 12. Card Distribution by Brand
SELECT 
    card_brand,
    COUNT(*) AS total_cards,
    COUNT(DISTINCT client_id) AS total_users
FROM cards_data_staging
GROUP BY card_brand
ORDER BY total_cards DESC;

-- 13. Average Credit Limit by Card Type
SELECT 
    card_type,
    AVG(credit_limit) AS avg_credit_limit,
    COUNT(*) AS total_cards
FROM cards_data_staging
GROUP BY card_type
ORDER BY avg_credit_limit DESC;

-- 14. Total Number of Transactions
SELECT COUNT(*) AS total_transactions
FROM transactions_data_staging;