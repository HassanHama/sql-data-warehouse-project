/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    Performs the ETL process to cleanse, standardize, and load data from the 
    Bronze layer into the Silver layer.
    
    Actions:
    - Truncates existing Silver tables.
    - Standardizes dates, genders, and country codes.
    - Resolves mathematical inconsistencies in sales data.
    - Adds metadata for traceability (source system and file location).
===============================================================================
*/

DELIMITER $$

CREATE PROCEDURE silver.load_silver()
BEGIN
    DECLARE start_time TIMESTAMP;
    DECLARE end_time TIMESTAMP;

    SET start_time = CURRENT_TIMESTAMP();
    SELECT '>> Starting Silver Layer Load...' AS message;

    -- ===========================================================================
    -- 1. CRM Tables
    -- ===========================================================================
    
    -- CRM Customer Info
    SELECT '>> Loading silver.crm_cust_info' AS message;
    TRUNCATE TABLE silver.crm_cust_info;
    INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date, file_location)
    SELECT cst_id, cst_key, TRIM(cst_firstname), TRIM(cst_lastname), 
           CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married' 
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' 
                ELSE 'n/a' END,
           CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' 
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' 
                ELSE 'n/a' END,
           cst_create_date, 'bronze.crm_cust_info'
    FROM bronze.crm_cust_info;

    -- CRM Product Info
    SELECT '>> Loading silver.crm_prd_info' AS message;
    TRUNCATE TABLE silver.crm_prd_info;
    INSERT INTO silver.crm_prd_info (prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt, file_location)
    SELECT prd_id, REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'), SUBSTRING(prd_key, 7), prd_nm, 
           IFNULL(prd_cost, 0), 
           CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain' 
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road' 
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring' 
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other' 
                ELSE 'n/a' END,
           CAST(prd_start_dt AS DATE), 
           LEAD(CAST(prd_start_dt AS DATE)) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL 1 DAY,
           'bronze.crm_prd_info'
    FROM bronze.crm_prd_info;

    -- CRM Sales Details
    SELECT '>> Loading silver.crm_sales_details' AS message;
    TRUNCATE TABLE silver.crm_sales_details;
    INSERT INTO silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price, file_location)
    SELECT sls_ord_num, sls_prd_key, sls_cust_id,
           CASE WHEN sls_order_dt <= 0 OR CHAR_LENGTH(CAST(sls_order_dt AS CHAR)) != 8 THEN NULL ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d') END,
           CASE WHEN sls_ship_dt <= 0 OR CHAR_LENGTH(CAST(sls_ship_dt AS CHAR)) != 8 THEN NULL ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d') END,
           CASE WHEN sls_due_dt <= 0 OR CHAR_LENGTH(CAST(sls_due_dt AS CHAR)) != 8 THEN NULL ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d') END,
           CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price) ELSE sls_sales END,
           sls_quantity,
           CASE WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0) ELSE sls_price END,
           'bronze.crm_sales_details'
    FROM bronze.crm_sales_details;

    -- ===========================================================================
    -- 2. ERP Tables
    -- ===========================================================================

    -- ERP Customer AZ12
    SELECT '>> Loading silver.erp_cust_az12' AS message;
    TRUNCATE TABLE silver.erp_cust_az12;
    INSERT INTO silver.erp_cust_az12 (cid, bdate, gen, file_location)
    SELECT CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4) ELSE cid END,
           CASE WHEN bdate > CURRENT_DATE() THEN NULL ELSE bdate END,
           CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female' WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male' ELSE 'n/a' END,
           'bronze.erp_cust_az12'
    FROM bronze.erp_cust_az12;

    -- ERP Location A101
    SELECT '>> Loading silver.erp_loc_a101' AS message;
    TRUNCATE TABLE silver.erp_loc_a101;
    INSERT INTO silver.erp_loc_a101 (cid, cntry, file_location)
    SELECT REPLACE(cid, '-', ''),
           CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany' WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States' WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a' ELSE TRIM(cntry) END,
           'bronze.erp_loc_a101'
    FROM bronze.erp_loc_a101;

    -- ERP Product Category
    SELECT '>> Loading silver.erp_px_cat_g1v2' AS message;
    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance, file_location)
    SELECT id, cat, subcat, maintenance, 'bronze.erp_px_cat_g1v2'
    FROM bronze.erp_px_cat_g1v2;

    SET end_time = CURRENT_TIMESTAMP();
    SELECT CONCAT('>> Success! Silver Layer Load duration: ', TIMEDIFF(end_time, start_time)) AS message;

END$$

DELIMITER ;
