-- ======================================================
-- DATA CLEANING
-- 1. Remove duplicate records
-- 2. Standardize data
-- 3. Check for NULL values
-- ======================================================

-- ======================================================
-- A. Copy Tables for Preparation
-- ======================================================
CREATE TABLE cards_data_staging LIKE cards_data;
CREATE TABLE transactions_data_staging LIKE transactions_data;
CREATE TABLE users_data_staging LIKE users_data;

INSERT INTO cards_data_staging SELECT * FROM cards_data;
INSERT INTO transactions_data_staging SELECT * FROM transactions_data;
INSERT INTO users_data_staging SELECT * FROM users_data;

-- Preview staging tables
SELECT * FROM cards_data_staging;
SELECT * FROM transactions_data_staging;
SELECT * FROM users_data_staging;

-- ======================================================
-- B. Remove Duplicate Records
-- ======================================================

-- Cards Data
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY client_id, card_brand, card_type, card_number, expires, cvv, has_chip,
                            num_cards_issued, credit_limit, acct_open_date, year_pin_last_changed, card_on_dark_web
               ORDER BY id
           ) AS row_num
    FROM cards_data_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

/* Uncomment to delete duplicates
DELETE FROM cards_data_staging
WHERE id IN (
    SELECT id FROM duplicate_cte WHERE row_num > 1
);
*/

-- Transactions Data
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY date, client_id, card_id, amount, use_chip, merchant_id, merchant_city,
                            merchant_state, zip, mcc
               ORDER BY id
           ) AS row_num
    FROM transactions_data_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

-- Users Data
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY current_age, retirement_age, birth_year, birth_month, gender, address, latitude,
                            longitude, per_capita_income, yearly_income, total_debt, credit_score, num_credit_cards
               ORDER BY id
           ) AS row_num
    FROM users_data_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

-- ======================================================
-- C. Standardize Data
-- ======================================================

-- 1. Cards Data
SELECT DISTINCT card_brand FROM cards_data_staging;
SELECT DISTINCT card_type FROM cards_data_staging;

-- Remove '$' from credit_limit and convert to DECIMAL
UPDATE cards_data_staging
SET credit_limit = REPLACE(credit_limit, '$', '');

ALTER TABLE cards_data_staging
MODIFY credit_limit DECIMAL(15,2);

-- 2. Transactions Data
UPDATE transactions_data_staging
SET amount = REPLACE(amount, '$', '');

ALTER TABLE transactions_data_staging
MODIFY amount DECIMAL(15,2);

SELECT DISTINCT merchant_city FROM transactions_data_staging;
SELECT DISTINCT merchant_state FROM transactions_data_staging;
SELECT DISTINCT errors FROM transactions_data_staging;

-- 3. Users Data
UPDATE users_data_staging
SET per_capita_income = REPLACE(per_capita_income, '$', ''),
    yearly_income = REPLACE(yearly_income, '$', ''),
    total_debt = REPLACE(total_debt, '$', '');

ALTER TABLE users_data_staging
MODIFY per_capita_income DECIMAL(15,2),
MODIFY yearly_income DECIMAL(15,2),
MODIFY total_debt DECIMAL(15,2);

-- Check for logical errors
SELECT * FROM users_data_staging WHERE current_age > retirement_age;
SELECT * FROM users_data_staging WHERE birth_month > 12;

-- ======================================================
-- D. Check for NULL Values
-- ======================================================
# cards_data_staging
SELECT * FROM cards_data_staging
WHERE client_id IS NULL OR card_brand IS NULL OR card_type IS NULL OR card_number IS NULL
   OR cvv IS NULL OR expires IS NULL OR has_chip IS NULL OR num_cards_issued IS NULL
   OR credit_limit IS NULL OR acct_open_date IS NULL OR year_pin_last_changed IS NULL
   OR card_on_dark_web IS NULL;
# trasactions_data_staging
SELECT * FROM transactions_data_staging
WHERE date IS NULL OR client_id IS NULL OR card_id IS NULL OR use_chip IS NULL
   OR merchant_id IS NULL OR merchant_city IS NULL OR merchant_state IS NULL
   OR zip IS NULL OR mcc IS NULL;
# users_data_staging
SELECT * FROM users_data_staging
WHERE current_age IS NULL OR retirement_age IS NULL OR birth_year IS NULL
   OR birth_month IS NULL OR address IS NULL OR latitude IS NULL OR longitude IS NULL
   OR per_capita_income IS NULL OR yearly_income IS NULL OR total_debt IS NULL
   OR credit_score IS NULL OR num_credit_cards IS NULL;