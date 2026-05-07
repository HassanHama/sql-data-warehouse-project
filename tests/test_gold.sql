/*
===============================================================================
Quality Audit Script: Gold Layer
===============================================================================
Purpose:
    Validates the integrity of the Star Schema and Business Logic.
    These tests ensure that the Dimensions and Facts are correctly linked.
===============================================================================
*/

USE gold;

-- 1. Check for Orphaned Sales (Referential Integrity)
-- Objective: Ensure every sale is linked to a valid customer and product.
SELECT 'Orphaned Product Keys' AS test_name, COUNT(*) AS issues
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
WHERE p.product_key IS NULL
UNION ALL
SELECT 'Orphaned Customer Keys', COUNT(*)
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

-- 2. Check for Surrogate Key Uniqueness
-- Objective: Ensure the ROW_NUMBER() logic didn't create duplicates.
SELECT 'Duplicate Product Keys' AS test_name, product_key, COUNT(*)
FROM gold.dim_products GROUP BY product_key HAVING COUNT(*) > 1
UNION ALL
SELECT 'Duplicate Customer Keys', customer_key, COUNT(*)
FROM gold.dim_customers GROUP BY customer_key HAVING COUNT(*) > 1;

-- 3. Business Rule: Sales Amount vs. Price & Quantity
-- Objective: Verify that the Gold layer maintains the math cleaned in Silver.
SELECT 'Invalid Sales Calculation' AS test_name, order_number, sales_amount
FROM gold.fact_sales
WHERE sales_amount != (quantity * price) OR sales_amount <= 0;

-- 4. Check for Consistency Between Layers
-- Objective: Ensure the total sales in Gold match the total sales in Silver.
SELECT 
    'Layer Reconciliation' AS test_name,
    (SELECT SUM(sls_sales) FROM silver.crm_sales_details) AS silver_total,
    (SELECT SUM(sales_amount) FROM gold.fact_sales) AS gold_total;

-- 5. Data Completeness (Critical Fields)
-- Objective: Ensure business-critical descriptive fields are not NULL.
SELECT 'Missing Product Names' AS test_name, COUNT(*)
FROM gold.dim_products WHERE product_name IS NULL OR product_name = ''
UNION ALL
SELECT 'Missing Customer Names', COUNT(*)
FROM gold.dim_customers WHERE first_name IS NULL OR last_name IS NULL;
