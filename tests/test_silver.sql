/*
===============================================================================
Quality Audit Script: Silver Layer
===============================================================================
Purpose:
    Validates the integrity of the Silver Layer data after the load process.
    Each query should ideally return NO results.
===============================================================================
*/

USE silver;

-- 1. Check for Duplicate IDs in Customers
-- Objective: Ensure 'cid' and 'cst_id' are unique after normalization.
SELECT 'Duplicate Customer IDs' AS test_name, cst_id, COUNT(*) 
FROM silver.crm_cust_info GROUP BY cst_id HAVING COUNT(*) > 1
UNION ALL
SELECT 'Duplicate ERP IDs', cid, COUNT(*) 
FROM silver.erp_cust_az12 GROUP BY cid HAVING COUNT(*) > 1;

-- 2. Check for Mathematical Inconsistency in Sales
-- Objective: Verify the 'Self-Healing' logic for Sales = Qty * Price.
SELECT 'Sales Consistency Error' AS test_name, sls_ord_num, sls_sales, (sls_quantity * sls_price) as expected
FROM silver.crm_sales_details
WHERE sls_sales != (sls_quantity * sls_price)
   OR sls_sales IS NULL OR sls_sales <= 0;

-- 3. Check for Out-of-Range Dates
-- Objective: Identify any dates that escaped the standardizing logic.
SELECT 'Future Birthdates' AS test_name, cid, bdate
FROM silver.erp_cust_az12
WHERE bdate > CURRENT_DATE();

-- 4. Check for Invalid Gender/Marital Status
-- Objective: Ensure only normalized values ('Male', 'Female', 'Married', 'Single', 'n/a') exist.
SELECT 'Invalid Gender Mapping' AS test_name, gen, COUNT(*)
FROM silver.erp_cust_az12
WHERE gen NOT IN ('Male', 'Female', 'n/a')
GROUP BY gen;

-- 5. Check for Referential Integrity (Orphaned Sales)
-- Objective: Ensure all sales records point to an existing product key.
SELECT 'Orphaned Product Keys' AS test_name, sls_prd_key, COUNT(*)
FROM silver.crm_sales_details s
LEFT JOIN silver.crm_prd_info p ON s.sls_prd_key = p.prd_key
WHERE p.prd_key IS NULL
GROUP BY sls_prd_key;
