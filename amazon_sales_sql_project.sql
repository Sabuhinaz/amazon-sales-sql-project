-- Amazon Sales SQL Portfolio Project
-- Database: ecommerce_sql_project
-- MySQL 8.0+

USE ecommerce_sql_project;

-- ============================================================
-- 1. BASIC EXPLORATION
-- ============================================================

SELECT * FROM amazon_sales LIMIT 10;

SELECT COUNT(*) AS total_rows FROM amazon_sales;

SELECT MIN(`Date`) AS earliest_date, MAX(`Date`) AS latest_date
FROM amazon_sales;

SELECT SUM(`Qty`) AS total_quantity,
       AVG(`Qty`) AS average_quantity,
       MIN(`Qty`) AS minimum_quantity,
       MAX(`Qty`) AS maximum_quantity
FROM amazon_sales;

SELECT `Status`, COUNT(*) AS order_count
FROM amazon_sales
GROUP BY `Status`
ORDER BY order_count DESC;

-- ============================================================
-- 2. FILTERING, NULLS, IN, BETWEEN, LIKE
-- ============================================================

SELECT COUNT(*) AS cancelled_records
FROM amazon_sales
WHERE `Status` = 'Cancelled';

SELECT SUM(`Qty`) AS cancelled_quantity
FROM amazon_sales
WHERE `Status` = 'Cancelled';

SELECT COUNT(*) AS qty_greater_than_5
FROM amazon_sales
WHERE `Qty` > 5;

SELECT COUNT(*) AS qty_less_than_2
FROM amazon_sales
WHERE `Qty` < 2;

SELECT COUNT(*) AS qty_equal_to_1
FROM amazon_sales
WHERE `Qty` = 1;

SELECT COUNT(*) AS qty_at_least_2
FROM amazon_sales
WHERE `Qty` >= 2;

SELECT COUNT(*) AS qty_between_1_and_5
FROM amazon_sales
WHERE `Qty` > 0 AND `Qty` < 5;

SELECT COUNT(*) AS qty_0_or_1
FROM amazon_sales
WHERE `Qty` = 0 OR `Qty` = 1;

SELECT COUNT(`Qty`) AS orders_0_1_or_2
FROM amazon_sales
WHERE `Qty` IN (0, 1, 2);

SELECT COUNT(`Qty`) AS orders_not_0_1_or_2
FROM amazon_sales
WHERE `Qty` NOT IN (0, 1, 2);

SELECT COUNT(*) AS orders_between_2_and_5
FROM amazon_sales
WHERE `Qty` BETWEEN 2 AND 5;

SELECT COUNT(*) AS orders_not_between_2_and_5
FROM amazon_sales
WHERE `Qty` NOT BETWEEN 2 AND 5;

SELECT COUNT(*) AS maharashtra_records
FROM amazon_sales
WHERE `ship-state` LIKE 'MAH%';

SELECT COUNT(*) AS delhi_city_records
FROM amazon_sales
WHERE `ship-city` LIKE '%DELHI%';

SELECT COUNT(*) AS missing_amount
FROM amazon_sales
WHERE `Amount` IS NULL;

SELECT COUNT(*) AS available_amount
FROM amazon_sales
WHERE `Amount` IS NOT NULL;

-- ============================================================
-- 3. BUSINESS KPIs
-- ============================================================

SELECT ROUND(SUM(`Amount`), 2) AS total_revenue,
       ROUND(AVG(`Amount`), 2) AS average_order_value,
       COUNT(*) AS total_order_records
FROM amazon_sales
WHERE `Amount` IS NOT NULL;

SELECT COUNT(DISTINCT `Order ID`) AS unique_orders
FROM amazon_sales;

SELECT COUNT(CASE WHEN `Status` = 'Cancelled' THEN 1 END) * 100.0 / COUNT(*)
       AS cancellation_rate
FROM amazon_sales;

-- ============================================================
-- 4. REVENUE AND PRODUCT ANALYSIS
-- ============================================================

SELECT `Category`, ROUND(SUM(`Amount`), 2) AS total_revenue
FROM amazon_sales
WHERE `Amount` IS NOT NULL
GROUP BY `Category`
ORDER BY total_revenue DESC;

SELECT `ship-state`, ROUND(SUM(`Amount`), 2) AS total_revenue
FROM amazon_sales
WHERE `Amount` IS NOT NULL
GROUP BY `ship-state`
ORDER BY total_revenue DESC;

SELECT DATE_FORMAT(`Date`, '%Y-%m') AS month,
       ROUND(SUM(`Amount`), 2) AS total_revenue
FROM amazon_sales
WHERE `Amount` IS NOT NULL
GROUP BY month
ORDER BY month;

SELECT `Fulfilment`, ROUND(SUM(`Amount`), 2) AS total_revenue,
       COUNT(*) AS order_records
FROM amazon_sales
WHERE `Amount` IS NOT NULL
GROUP BY `Fulfilment`
ORDER BY total_revenue DESC;

SELECT `Sales Channel`, ROUND(SUM(`Amount`), 2) AS total_revenue
FROM amazon_sales
WHERE `Amount` IS NOT NULL
GROUP BY `Sales Channel`
ORDER BY total_revenue DESC;

SELECT `Status`, ROUND(SUM(`Amount`), 2) AS total_revenue
FROM amazon_sales
WHERE `Amount` IS NOT NULL
GROUP BY `Status`
ORDER BY total_revenue DESC;

SELECT `Style`, ROUND(SUM(`Amount`), 2) AS total_revenue
FROM amazon_sales
WHERE `Amount` IS NOT NULL
GROUP BY `Style`
ORDER BY total_revenue DESC
LIMIT 10;

SELECT `ship-city`, ROUND(SUM(`Amount`), 2) AS total_revenue
FROM amazon_sales
WHERE `Amount` IS NOT NULL
GROUP BY `ship-city`
ORDER BY total_revenue DESC
LIMIT 10;

SELECT `SKU`, SUM(`Qty`) AS total_quantity
FROM amazon_sales
WHERE `Qty` > 0
GROUP BY `SKU`
ORDER BY total_quantity DESC
LIMIT 10;

SELECT `Category`, SUM(`Qty`) AS total_quantity
FROM amazon_sales
WHERE `Qty` > 0
GROUP BY `Category`
ORDER BY total_quantity DESC;

SELECT `Category`, ROUND(AVG(`Amount`), 2) AS average_order_value
FROM amazon_sales
WHERE `Amount` IS NOT NULL
GROUP BY `Category`
ORDER BY average_order_value DESC;

-- ============================================================
-- 5. DATA CLEANING
-- ============================================================

DROP TABLE IF EXISTS amazon_sales_clean;

CREATE TABLE amazon_sales_clean AS
SELECT * FROM amazon_sales;

UPDATE amazon_sales_clean
SET `ship-city` = 'PUNE'
WHERE LOWER(`ship-city`) = 'pune';

UPDATE amazon_sales_clean
SET `ship-state` = CASE
    WHEN `ship-state` = 'New Delhi' THEN 'DELHI'
    WHEN `ship-state` = 'Goa' THEN 'GOA'
    WHEN `ship-state` = 'Gujarat' THEN 'GUJARAT'
    WHEN `ship-state` = 'orissa' THEN 'ODISHA'
    WHEN `ship-state` = 'Pondicherry' THEN 'PUDUCHERRY'
    WHEN `ship-state` = 'Rajshthan' THEN 'RAJASTHAN'
    WHEN `ship-state` = 'rajsthan' THEN 'RAJASTHAN'
    WHEN `ship-state` = 'RJ' THEN 'RAJASTHAN'
    WHEN `ship-state` = 'NL' THEN 'NAGALAND'
    WHEN `ship-state` = 'PB' THEN 'PUNJAB'
    WHEN `ship-state` = 'Punjab/Mohali/Zirakpur' THEN 'PUNJAB'
    WHEN `ship-state` = 'AR' THEN 'ARUNACHAL PRADESH'
    ELSE `ship-state`
END;

SELECT
    SUM(`Order ID` IS NULL OR `Order ID` = '') AS missing_order_id,
    SUM(`Date` IS NULL) AS missing_date,
    SUM(`Status` IS NULL OR `Status` = '') AS missing_status,
    SUM(`SKU` IS NULL OR `SKU` = '') AS missing_sku,
    SUM(`Category` IS NULL OR `Category` = '') AS missing_category,
    SUM(`Qty` IS NULL) AS missing_qty,
    SUM(`Amount` IS NULL) AS missing_amount,
    SUM(`ship-city` IS NULL OR `ship-city` = '') AS missing_city,
    SUM(`ship-state` IS NULL OR `ship-state` = '') AS missing_state,
    SUM(`ship-country` IS NULL OR `ship-country` = '') AS missing_country
FROM amazon_sales_clean;

SELECT MIN(`Qty`) AS minimum_quantity,
       MAX(`Qty`) AS maximum_quantity,
       COUNT(*) AS negative_quantity_rows
FROM amazon_sales_clean
WHERE `Qty` < 0;

-- ============================================================
-- 6. DUPLICATE DETECTION AND REMOVAL
-- ============================================================

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT `Order ID`) AS unique_orders
FROM amazon_sales_clean;

SELECT `Order ID`, `SKU`, `Date`, `Status`, `Fulfilment`, `Category`,
       `Size`, `Qty`, `Amount`, `ship-city`, `ship-state`, `ship-country`,
       COUNT(*) AS duplicate_count
FROM amazon_sales_clean
GROUP BY `Order ID`, `SKU`, `Date`, `Status`, `Fulfilment`, `Category`,
         `Size`, `Qty`, `Amount`, `ship-city`, `ship-state`, `ship-country`
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

DELETE FROM amazon_sales_clean
WHERE `index` IN (
    SELECT `index`
    FROM (
        SELECT `index`,
               ROW_NUMBER() OVER (
                   PARTITION BY `Order ID`, `SKU`, `Date`, `Status`,
                                `Fulfilment`, `Category`, `Size`, `Qty`,
                                `Amount`, `ship-city`, `ship-state`, `ship-country`
                   ORDER BY `index`
               ) AS rn
        FROM amazon_sales_clean
    ) AS duplicates
    WHERE rn > 1
);

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT `Order ID`) AS unique_orders
FROM amazon_sales_clean;

-- ============================================================
-- 7. CLEANED DATA ANALYSIS
-- ============================================================

SELECT COUNT(*) AS multi_product_orders
FROM (
    SELECT `Order ID`, COUNT(DISTINCT `SKU`) AS product_count
    FROM amazon_sales_clean
    GROUP BY `Order ID`
    HAVING COUNT(DISTINCT `SKU`) > 1
) AS order_summary;

SELECT AVG(product_count) AS avg_products_per_order
FROM (
    SELECT `Order ID`, COUNT(DISTINCT `SKU`) AS product_count
    FROM amazon_sales_clean
    GROUP BY `Order ID`
) AS order_summary;

SELECT `SKU`, ROUND(SUM(`Amount`), 2) AS total_revenue
FROM amazon_sales_clean
WHERE `Amount` IS NOT NULL
GROUP BY `SKU`
ORDER BY total_revenue DESC
LIMIT 10;

SELECT `Category`, SUM(`Qty`) AS total_quantity
FROM amazon_sales_clean
WHERE `Qty` > 0
GROUP BY `Category`
ORDER BY total_quantity DESC;

SELECT `Category`, ROUND(AVG(`Amount`), 2) AS average_order_value
FROM amazon_sales_clean
WHERE `Amount` IS NOT NULL
GROUP BY `Category`
ORDER BY average_order_value DESC;

SELECT `Category`,
       ROUND(SUM(`Amount`), 2) AS category_revenue,
       ROUND(SUM(`Amount`) * 100.0 /
             (SELECT SUM(`Amount`) FROM amazon_sales_clean WHERE `Amount` IS NOT NULL), 2)
             AS revenue_percentage
FROM amazon_sales_clean
WHERE `Amount` IS NOT NULL
GROUP BY `Category`
ORDER BY category_revenue DESC;

SELECT `Fulfilment`,
       COUNT(DISTINCT `Order ID`) AS unique_orders,
       ROUND(AVG(`Amount`), 2) AS average_order_value,
       ROUND(SUM(`Amount`), 2) AS total_revenue
FROM amazon_sales_clean
WHERE `Amount` IS NOT NULL
GROUP BY `Fulfilment`
ORDER BY average_order_value DESC;

SELECT DATE_FORMAT(`Date`, '%Y-%m') AS month,
       ROUND(SUM(`Amount`), 2) AS total_revenue
FROM amazon_sales_clean
WHERE `Amount` IS NOT NULL
GROUP BY month
ORDER BY month;

SELECT DATE_FORMAT(`Date`, '%Y-%m') AS month,
       COUNT(DISTINCT `Order ID`) AS unique_orders
FROM amazon_sales_clean
GROUP BY month
ORDER BY month;

SELECT `ship-state`,
       ROUND(SUM(`Amount`), 2) AS total_revenue,
       COUNT(DISTINCT `Order ID`) AS unique_orders
FROM amazon_sales_clean
WHERE `Amount` IS NOT NULL AND `ship-state` <> ''
GROUP BY `ship-state`
ORDER BY total_revenue DESC
LIMIT 10;

SELECT `Category`,
       COUNT(DISTINCT `Order ID`) AS total_orders,
       COUNT(DISTINCT CASE WHEN `Status` = 'Cancelled' THEN `Order ID` END)
           AS cancelled_orders,
       ROUND(COUNT(DISTINCT CASE WHEN `Status` = 'Cancelled' THEN `Order ID` END)
             * 100.0 / COUNT(DISTINCT `Order ID`), 2) AS cancellation_rate
FROM amazon_sales_clean
GROUP BY `Category`
ORDER BY cancellation_rate DESC;

SELECT `ship-state`,
       COUNT(DISTINCT `Order ID`) AS total_orders,
       COUNT(DISTINCT CASE WHEN `Status` = 'Cancelled' THEN `Order ID` END)
           AS cancelled_orders,
       ROUND(COUNT(DISTINCT CASE WHEN `Status` = 'Cancelled' THEN `Order ID` END)
             * 100.0 / COUNT(DISTINCT `Order ID`), 2) AS cancellation_rate
FROM amazon_sales_clean
WHERE `ship-state` <> ''
GROUP BY `ship-state`
HAVING COUNT(DISTINCT `Order ID`) >= 100
ORDER BY cancellation_rate DESC
LIMIT 10;

SELECT `Fulfilment`, `Status`, COUNT(DISTINCT `Order ID`) AS unique_orders
FROM amazon_sales_clean
GROUP BY `Fulfilment`, `Status`
ORDER BY `Fulfilment`, unique_orders DESC;

SELECT `Category`,
       SUM(`Qty`) AS total_quantity,
       ROUND(SUM(`Amount`), 2) AS total_revenue,
       ROUND(AVG(`Amount`), 2) AS average_order_value
FROM amazon_sales_clean
WHERE `Qty` > 0 AND `Amount` IS NOT NULL
GROUP BY `Category`
ORDER BY total_revenue DESC;

-- ============================================================
-- 8. CTE + WINDOW FUNCTION + RANK()
-- ============================================================

WITH sku_revenue AS (
    SELECT `Category`, `SKU`, ROUND(SUM(`Amount`), 2) AS total_revenue
    FROM amazon_sales_clean
    WHERE `Amount` IS NOT NULL
    GROUP BY `Category`, `SKU`
),
ranked_skus AS (
    SELECT `Category`, `SKU`, total_revenue,
           RANK() OVER (
               PARTITION BY `Category`
               ORDER BY total_revenue DESC
           ) AS revenue_rank
    FROM sku_revenue
)
SELECT `Category`, `SKU`, total_revenue, revenue_rank
FROM ranked_skus
WHERE revenue_rank <= 3
ORDER BY `Category`, revenue_rank;

-- ============================================================
-- 9. ADVANCED BUSINESS ANALYSIS
-- ============================================================

SELECT `Fulfilment`,
       COUNT(DISTINCT `Order ID`) AS total_orders,
       COUNT(DISTINCT CASE WHEN `Status` = 'Cancelled' THEN `Order ID` END)
           AS cancelled_orders,
       ROUND(COUNT(DISTINCT CASE WHEN `Status` = 'Cancelled' THEN `Order ID` END)
             * 100.0 / COUNT(DISTINCT `Order ID`), 2) AS cancellation_rate
FROM amazon_sales_clean
GROUP BY `Fulfilment`
ORDER BY cancellation_rate DESC;

SELECT `ship-state`,
       COUNT(DISTINCT `Order ID`) AS unique_orders,
       ROUND(AVG(`Amount`), 2) AS average_order_value,
       ROUND(SUM(`Amount`), 2) AS total_revenue
FROM amazon_sales_clean
WHERE `Amount` IS NOT NULL AND `ship-state` <> ''
GROUP BY `ship-state`
HAVING COUNT(DISTINCT `Order ID`) >= 100
ORDER BY average_order_value DESC
LIMIT 10;

SELECT `ship-state`,
       ROUND(SUM(`Amount`), 2) AS total_revenue,
       COUNT(DISTINCT `Order ID`) AS unique_orders,
       ROUND(SUM(`Amount`) * 100.0 /
             (SELECT SUM(`Amount`) FROM amazon_sales_clean WHERE `Amount` IS NOT NULL), 2)
             AS revenue_percentage
FROM amazon_sales_clean
WHERE `Amount` IS NOT NULL AND `ship-state` <> ''
GROUP BY `ship-state`
ORDER BY revenue_percentage DESC
LIMIT 10;

SELECT `Status`,
       ROUND(SUM(`Amount`), 2) AS total_revenue,
       COUNT(DISTINCT `Order ID`) AS unique_orders,
       ROUND(SUM(`Amount`) * 100.0 /
             (SELECT SUM(`Amount`) FROM amazon_sales_clean WHERE `Amount` IS NOT NULL), 2)
             AS revenue_percentage
FROM amazon_sales_clean
WHERE `Amount` IS NOT NULL
GROUP BY `Status`
ORDER BY total_revenue DESC;

SELECT CASE
           WHEN `Amount` < 500 THEN 'Low Value'
           WHEN `Amount` BETWEEN 500 AND 1000 THEN 'Medium Value'
           WHEN `Amount` > 1000 THEN 'High Value'
       END AS order_value_category,
       COUNT(*) AS order_records,
       ROUND(SUM(`Amount`), 2) AS total_revenue,
       ROUND(AVG(`Amount`), 2) AS average_amount
FROM amazon_sales_clean
WHERE `Amount` IS NOT NULL
GROUP BY order_value_category
ORDER BY total_revenue DESC;

-- ============================================================
-- END OF PROJECT
-- ============================================================
