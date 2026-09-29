# Amazon Sales SQL Analysis

## Project Overview

This project analyzes an Amazon sales dataset using **MySQL** to understand sales performance, customer orders, product performance, fulfilment, cancellations, and geographic trends.

The project includes data cleaning, validation, exploratory analysis, business KPI analysis, subqueries, CTEs, and window functions.

## Tools & Technologies

* MySQL 8.0
* MySQL Shell
* SQL
* GitHub

## Dataset

The dataset contains Amazon sales transaction records with information such as:

* Order ID
* Order date
* Order status
* Product SKU
* Category
* Quantity
* Amount
* Fulfilment
* Sales channel
* Shipping city
* Shipping state
* Shipping country

The original dataset contains **128,975 records**.

After data cleaning and removal of **6 exact duplicate records**, the cleaned dataset contains **128,969 records**.

## SQL Concepts Used

This project demonstrates:

* SELECT
* WHERE
* GROUP BY
* ORDER BY
* HAVING
* COUNT
* COUNT(DISTINCT)
* SUM
* AVG
* MIN and MAX
* LIKE
* IN and NOT IN
* BETWEEN
* IS NULL and IS NOT NULL
* CASE WHEN
* Subqueries
* Common Table Expressions (CTEs)
* Window Functions
* RANK()
* PARTITION BY
* Percentage calculations
* Duplicate detection
* Data cleaning and validation

## Data Cleaning

The cleaning process included:

* Standardizing inconsistent state names
* Standardizing city names such as Pune
* Identifying missing values
* Checking invalid quantity values
* Detecting exact duplicate records
* Removing only confirmed exact duplicates
* Preserving repeated Order IDs when they represented legitimate multi-product orders

Missing `Amount` values were retained as NULL rather than incorrectly replacing them with zero.

## Key Business Analysis

The project analyzes:

1. Total revenue and average order value
2. Order status distribution
3. Cancellation rate
4. Revenue by product category
5. Revenue by state
6. Monthly revenue trends
7. Revenue by fulfilment method
8. Top SKUs by revenue
9. Quantity sold by category
10. Average order value by category
11. Multi-product orders
12. Cancellation rate by category
13. Cancellation rate by state
14. Cancellation rate by fulfilment
15. Revenue contribution by category and state
16. Order value classification
17. Top 3 SKUs within each category using `RANK()`

## Key Findings

* Total recorded revenue with available `Amount` values was approximately **₹78.59 million**.
* The overall cancellation rate was approximately **14.21%** of order records.
* **Set** was the largest revenue-generating category, contributing approximately **49.88%** of recorded revenue.
* **Kurta** contributed approximately **27.10%** of recorded revenue.
* Set and kurta together contributed approximately **76.98%** of recorded revenue.
* Amazon fulfilment generated approximately **₹54.32 million** in recorded revenue, compared with approximately **₹24.27 million** for Merchant fulfilment.
* **Maharashtra** generated the highest recorded revenue among states, followed by **Karnataka**.
* The cleaned dataset contained **6,840 unique multi-product orders**.
* The average number of distinct SKUs per order was approximately **1.07**.
* Merchant fulfilment had a higher cancellation rate than Amazon fulfilment in this dataset.

## Advanced SQL

A CTE and window function were used to rank SKUs within each product category.

Example techniques include:

```sql
WITH sku_revenue AS (
    SELECT
        `Category`,
        `SKU`,
        SUM(`Amount`) AS total_revenue
    FROM amazon_sales_clean
    WHERE `Amount` IS NOT NULL
    GROUP BY `Category`, `SKU`
),
ranked_skus AS (
    SELECT
        `Category`,
        `SKU`,
        total_revenue,
        RANK() OVER (
            PARTITION BY `Category`
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM sku_revenue
)
SELECT *
FROM ranked_skus
WHERE revenue_rank <= 3;
```

## Project Structure

```text
amazon-sales-sql-project/
│
├── amazon_sales_sql_project.sql
└── README.md
```

## Conclusion

This project demonstrates practical SQL skills by transforming a raw e-commerce dataset into a cleaned dataset and extracting business insights through structured SQL analysis.

It combines fundamental SQL querying with advanced techniques such as CTEs, subqueries, conditional aggregation, percentage calculations, and window functions.
