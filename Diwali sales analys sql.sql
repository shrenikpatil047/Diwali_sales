SELECT VERSION();                  -- must be 8.0 or higher for window functions and CTEs
DESCRIBE diwali_sales;
SELECT COUNT(*) FROM diwali_sales; -- expect 11251

USE your_database_name;            -- put your database name here
SET SQL_SAFE_UPDATES = 0;          -- lets DELETE run without a key

-- Fix the column name with a space (skip if it's already age_group)
ALTER TABLE diwali_sales RENAME COLUMN `Age Group` TO age_group;

-- Drop the two blank columns
ALTER TABLE diwali_sales DROP COLUMN Status, DROP COLUMN unnamed1;

-- Check null amounts (expect 12)
SELECT COUNT(*) AS null_amounts FROM diwali_sales WHERE amount IS NULL;

-- Delete them
DELETE FROM diwali_sales WHERE amount IS NULL;

-- Final count (expect 11239)
SELECT COUNT(*) AS rows_after_cleaning FROM diwali_sales;



-- OVERALL NUMBERS

SELECT COUNT(DISTINCT user_id)              AS unique_customers,
       SUM(orders)                          AS total_orders,
       SUM(amount)                          AS total_sales,
       ROUND(SUM(amount) / SUM(orders), 2)  AS sales_per_order,
       ROUND(AVG(amount), 2)                AS avg_amount
FROM diwali_sales;


-- MAIN ANALYSE

-- Gender
SELECT gender,
       COUNT(*)    AS buyers,
       SUM(amount) AS total_sales,
       ROUND(100 * SUM(amount) / SUM(SUM(amount)) OVER (), 2) AS pct_of_sales
FROM diwali_sales
GROUP BY gender
ORDER BY total_sales DESC;

-- Age group
SELECT age_group,
       COUNT(*)    AS buyers,
       SUM(amount) AS total_sales
FROM diwali_sales
GROUP BY age_group
ORDER BY total_sales DESC;

-- Top 10 states
SELECT RANK() OVER (ORDER BY SUM(amount) DESC) AS sales_rank,
       state,
       SUM(orders) AS total_orders,
       SUM(amount) AS total_sales
FROM diwali_sales
GROUP BY state
ORDER BY sales_rank
LIMIT 10;

-- Zone
SELECT zone,
       SUM(amount) AS total_sales,
       ROUND(100 * SUM(amount) / SUM(SUM(amount)) OVER (), 2) AS pct_of_sales
FROM diwali_sales
GROUP BY zone
ORDER BY total_sales DESC;

-- Marital status and gender
SELECT CASE WHEN marital_status = 1 THEN 'Married' ELSE 'Unmarried' END AS marital,
       gender,
       COUNT(*)    AS buyers,
       SUM(amount) AS total_sales
FROM diwali_sales
GROUP BY marital_status, gender
ORDER BY total_sales DESC;


-- Occupation
SELECT occupation,
       COUNT(*)    AS buyers,
       SUM(amount) AS total_sales
FROM diwali_sales
GROUP BY occupation
ORDER BY total_sales DESC;


-- Top 10 product categories
SELECT product_category,
       COUNT(*)    AS buyers,
       SUM(amount) AS total_sales
FROM diwali_sales
GROUP BY product_category
ORDER BY total_sales DESC
LIMIT 10;


-- Top 10 most sold products
SELECT product_id, SUM(orders) AS total_orders
FROM diwali_sales
GROUP BY product_id
ORDER BY total_orders DESC
LIMIT 10;


-- Top 3 categories in each zone
WITH zone_cat AS (
    SELECT zone, product_category, SUM(amount) AS total_sales
    FROM diwali_sales
    GROUP BY zone, product_category
),
ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY zone ORDER BY total_sales DESC) AS rn
    FROM zone_cat
)
SELECT zone, product_category, total_sales, rn AS rank_in_zone
FROM ranked
WHERE rn <= 3
ORDER BY zone, rn;

-- Top 10 customers by total spend
SELECT user_id, cust_name,
       SUM(orders) AS total_orders,
       SUM(amount) AS total_spent,
       DENSE_RANK() OVER (ORDER BY SUM(amount) DESC) AS spend_rank
FROM diwali_sales
GROUP BY user_id, cust_name
ORDER BY spend_rank
LIMIT 10;

-- Best buyer segments
SELECT gender, age_group,
       CASE WHEN marital_status = 1 THEN 'Married' ELSE 'Unmarried' END AS marital,
       COUNT(*)    AS buyers,
       SUM(amount) AS total_sales
FROM diwali_sales
GROUP BY gender, age_group, marital_status
ORDER BY total_sales DESC
LIMIT 10;

-- Cumulative % of sales by state
WITH state_sales AS (
    SELECT state, SUM(amount) AS total_sales
    FROM diwali_sales
    GROUP BY state
)
SELECT state, total_sales,
       ROUND(100 * SUM(total_sales) OVER (ORDER BY total_sales DESC)
                 / SUM(total_sales) OVER (), 2) AS cumulative_pct
FROM state_sales
ORDER BY total_sales DESC;