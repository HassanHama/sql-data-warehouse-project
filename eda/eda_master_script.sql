/*
===============================================================================
Exploratory Data Analysis (EDA) - Gold Layer
===============================================================================
Project: Medallion Architecture Data Warehouse Audit
Author: Mohammed Alhassan
Date: May 2026
Purpose: 
    - To perform a comprehensive audit of the 'Gold' layer dimensions and facts.
    - To identify data quality issues, referential integrity gaps, and business trends.
    - To analyze product performance, customer demographics, and seasonality.
===============================================================================
*/

-- Set the context
USE gold;

-- =============================================================================
-- 1. METADATA & SCHEMA EXPLORATION
-- =============================================================================

-- List all tables in the Gold schema
SELECT * FROM information_schema.tables WHERE table_schema = 'gold';

-- List all columns in the fact_sales table
SELECT * FROM information_schema.columns WHERE table_name = 'fact_sales' AND table_schema = 'gold';


-- =============================================================================
-- 2. MEASURE EXPLORATION (High-Level Metrics)
-- =============================================================================

-- Generate a comprehensive metrics report
SELECT 'Total_sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total_quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average_price', ROUND(AVG(price), 2) FROM gold.fact_sales
UNION ALL
SELECT 'Total_num_orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total_num_products', COUNT(product_key) FROM gold.dim_products
UNION ALL 
SELECT 'Total_num_customers', COUNT(DISTINCT customer_id) FROM gold.dim_customers
UNION ALL
SELECT 'Total_num_customers_with_orders', COUNT(DISTINCT customer_key) FROM gold.fact_sales;


-- =============================================================================
-- 3. DATA QUALITY AUDIT
-- =============================================================================

-- Identify "Suspicious" rows (Zero or Negative Sales)
SELECT COUNT(*) AS total_suspicious_rows 
FROM gold.fact_sales 
WHERE sales_amount <= 0 OR quantity <= 0;

-- Audit for Duplicate Surrogate Keys per Natural Key (SCD Type 2 Check)
SELECT 
    customer_id, 
    COUNT(DISTINCT customer_key) AS keys_assigned
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(DISTINCT customer_key) > 1;

-- Check for Orphaned Sales (Transactions without matching customers)
SELECT DISTINCT customer_key 
FROM gold.fact_sales
WHERE customer_key NOT IN (SELECT customer_key FROM gold.dim_customers);


-- =============================================================================
-- 4. MAGNITUDE & DIMENSION ANALYSIS
-- =============================================================================

-- Customer Distribution by Country
SELECT country, COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Customer Distribution by Gender
SELECT gender, COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender;

-- Product Inventory by Category
SELECT category, COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Revenue and Avg Cost per Category
SELECT 
    p.category,
    ROUND(AVG(p.cost), 2) AS average_cost,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;


-- =============================================================================
-- 5. TEMPORAL (TIME-SERIES) ANALYSIS
-- =============================================================================

-- Yearly Revenue Growth
SELECT 
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_revenue,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Seasonal Performance Audit
SELECT 
    CASE 
        WHEN MONTH(order_date) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(order_date) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(order_date) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(order_date) IN (9, 10, 11) THEN 'Autumn'
    END AS season,
    SUM(sales_amount) AS total_revenue
FROM gold.fact_sales
GROUP BY season
ORDER BY total_revenue DESC;


-- =============================================================================
-- 6. RANKING & PERFORMANCE (WINDOW FUNCTIONS)
-- =============================================================================

-- Top 5 Highest Revenue Products
SELECT * FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
    GROUP BY p.product_name
) t WHERE rank_products <= 5;

-- Top 10 High-Value Customers
SELECT 
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC
LIMIT 10;
