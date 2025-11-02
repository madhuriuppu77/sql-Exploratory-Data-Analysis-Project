/*
==========================================================
CREATE VIEW: gold.report_products
==========================================================

 Purpose:
This view consolidates key product metrics and performance
data to identify top-selling, mid-performing, and low-performing
products based on total revenue and sales trends.

==========================================================
*/

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
WITH base_query AS (
    SELECT
        f.order_number,
        f.order_date,
        f.sales_amount,
        f.quantity,
        f.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        f.customer_key
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

product_aggregation AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT customer_key) AS total_customers,
        MAX(order_date) AS last_sale_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY product_key, product_name, category, subcategory, cost
),

product_segmentation AS (
    SELECT
        *,
        CASE 
            WHEN total_sales >= 8000 THEN 'High Performer'
            WHEN total_sales BETWEEN 4000 AND 7999 THEN 'Mid-Range'
            ELSE 'Low Performer'
        END AS product_segment
    FROM product_aggregation
),

final_report AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS r_number,
        product_name,
        category,
        subcategory,
        cost,
        product_segment,
        total_orders,
        total_sales,
        total_quantity,
        total_customers,
        lifespan,
        last_sale_date,
        DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency,
        CASE WHEN total_orders = 0 THEN 0
             ELSE total_sales / total_orders END AS avg_order_revenue,
        CASE WHEN lifespan = 0 THEN total_sales
             ELSE total_sales / lifespan END AS avg_monthly_revenue
    FROM product_segmentation
)

SELECT *
FROM final_report;
GO


