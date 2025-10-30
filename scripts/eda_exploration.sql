-- =============================================================
-- Project: Exploratory Data Analysis (EDA) on Data Warehouse
-- Layer: Gold (Fact & Dimension Views)
-- Author: Madhuri Uppunuthula
-- Description: Exploring business insights using Gold Layer
-- =============================================================

---------------------------------------------------------------
-- 🔍 EXPLORE DATABASE STRUCTURE
---------------------------------------------------------------

-- Explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Explore all columns in the database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

-- Explore all columns for a particular table
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

---------------------------------------------------------------
-- 🌍 EXPLORE DIMENSIONS
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
-- ⏰ EXPLORE DATE RANGE
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
-- 👤 CUSTOMER AGE ANALYSIS
---------------------------------------------------------------

-- Find youngest and oldest customers
SELECT 
    MIN(birthdate) AS oldest_birthdate,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers;

---------------------------------------------------------------
-- 📊 KEY BUSINESS METRICS
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
-- 🌎 CUSTOMER DISTRIBUTION
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
-- 🏷️ PRODUCT ANALYSIS
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
-- 💰 REVENUE ANALYSIS
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
-- 🏆 TOP & BOTTOM PERFORMANCE ANALYSIS
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

-- =============================================================
-- END OF SCRIPT
-- =============================================================
