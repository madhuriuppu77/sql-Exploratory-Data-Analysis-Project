-- =============================================================
-- Project: Exploratory Data Analysis (EDA) on Data Warehouse
-- Layer: Gold (Fact & Dimension Views)
-- Author: Madhuri Uppunuthula
-- Description: Exploring business insights using Gold Layer
-- =============================================================

---------------------------------------------------------------
-- 1 EXPLORE DATABASE STRUCTURE
---------------------------------------------------------------

-- Explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Explore all columns in the database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

-- Explore all columns for a particular table
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

---------------------------------------------------------------
-- 2 EXPLORE DIMENSIONS
---------------------------------------------------------------

-- Explore all countries where customers come from
SELECT DISTINCT country FROM gold.dim_customers;

-- Explore product categories
SELECT DISTINCT category FROM gold.dim_products;

-- Explore category and subcategory combinations
SELECT DISTINCT category, subcategory FROM gold.dim_products;

-- Explore detailed product hierarchy
SELECT DISTINCT category, subcategory, product_name 
FROM gold.dim_products
ORDER BY 1,2,3;

---------------------------------------------------------------
-- 3 EXPLORE DATE RANGE
---------------------------------------------------------------

-- Find the first and last order date
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS latest_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_year,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_month,
    DATEDIFF(DAY, MIN(order_date), MAX(order_date)) AS order_range_day
FROM gold.fact_sales;

---------------------------------------------------------------
-- 4 CUSTOMER AGE ANALYSIS
---------------------------------------------------------------

-- Find youngest and oldest customers
SELECT 
    MIN(birthdate) AS oldest_birthdate,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;

---------------------------------------------------------------
-- 5 KEY BUSINESS METRICS
---------------------------------------------------------------

-- Generate a report showing all key business metrics
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products', COUNT(product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers', COUNT(customer_key) FROM gold.dim_customers;

---------------------------------------------------------------
-- 6 CUSTOMER DISTRIBUTION
---------------------------------------------------------------

-- Total number of customers by country
SELECT 
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Total customers by gender
SELECT 
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

---------------------------------------------------------------
-- 7 PRODUCT ANALYSIS
---------------------------------------------------------------

-- Total products by category
SELECT 
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Average cost in each category
SELECT 
    category,
    AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

---------------------------------------------------------------
-- 8 REVENUE ANALYSIS
---------------------------------------------------------------

-- Total revenue by category
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Total revenue by customer
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC;

-- Distribution of items sold across countries
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;

---------------------------------------------------------------
-- 9 TOP & BOTTOM PERFORMANCE ANALYSIS
---------------------------------------------------------------

-- Top 5 best-performing products (highest revenue)
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- 5 worst-performing products (lowest revenue)
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;

/*
==========================================================
 Advance Exploratory Data Analysis (EDA) and Sales Performance SQL
==========================================================

This SQL script performs various exploratory data analysis (EDA)
and performance evaluations using data from the `gold` schema.

Includes:
1. Change Over Time Analysis
2. Cumulative Analysis (with Running Total and Moving Average)
3. Performance Analysis (Yearly)
4. Part-to-Whole Contribution Analysis
5. Customer Segmentation Analysis

==========================================================
*/


/* ========================================================
   1. CHANGE OVER TIME ANALYSIS
   Objective: Analyze sales trends by year, month, and monthly pattern.
===========================================================
*/

-- Yearly performance summary
SELECT 
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

-- Monthly performance summary (aggregated across all years)
SELECT 
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);

-- Year-Month combination (sales trends per month per year)
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);


/* ========================================================
   2. CUMULATIVE ANALYSIS
   Objective: Calculate monthly total sales and track cumulative growth over time.
===========================================================
*/

-- Monthly total sales
SELECT
    DATETRUNC(month, order_date) AS order_month,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

-- Monthly total sales with running total and moving average
SELECT
    order_month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_month) AS running_total_sales,
    AVG(avg_price) OVER (ORDER BY order_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_price
FROM (
    SELECT
        DATETRUNC(month, order_date) AS order_month,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) t;


/* ========================================================
   3. PERFORMANCE ANALYSIS
   Objective: Compare yearly product performance vs. average and previous year.
===========================================================
*/

WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        YEAR(f.order_date),
        p.product_name
)

SELECT
    order_year,
    product_name,
    current_sales,

    -- Average sales across all years for the same product
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,

    -- Difference from average
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,

    -- Performance classification vs. average
    CASE 
        WHEN current_sales > AVG(current_sales) OVER (PARTITION BY product_name) THEN 'Above Avg'
        WHEN current_sales < AVG(current_sales) OVER (PARTITION BY product_name) THEN 'Below Avg'
        ELSE 'Average'
    END AS avg_change,

    -- Previous year's sales
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS prev_year_sales,

    -- Difference from previous year
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_prev_year,

    -- Year-over-year classification
    CASE 
        WHEN current_sales > LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) THEN 'Increase'
        WHEN current_sales < LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) THEN 'Decrease'
        ELSE 'No Change'
    END AS year_change

FROM yearly_product_sales
ORDER BY product_name, order_year;


/* ========================================================
   4. PART-TO-WHOLE ANALYSIS
   Objective: Determine category-wise contribution to overall sales.
===========================================================
*/

WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)

SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(
        ROUND(
            (CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 
            2
        ),
        '%'
    ) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;


/* ========================================================
   5. CUSTOMER SEGMENTATION ANALYSIS
   Objective: Group customers based on spending behavior and lifespan.
===========================================================
*/

-- Step 1: Calculate total spending and customer lifespan
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(f.order_date) AS first_order,
        MAX(f.order_date) AS last_order,
        DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)

-- Step 2: Segment customers by behavior
SELECT
    CASE 
        WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    COUNT(customer_key) AS total_customers
FROM customer_spending
GROUP BY 
    CASE 
        WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
        ELSE 'New'
    END
ORDER BY total_customers DESC;

