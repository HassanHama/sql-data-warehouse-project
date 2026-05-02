/*
===============================================================================
Loading Script: Load Bronze Layer
===============================================================================
Script Purpose:
    This script loads data from external CSV files into the Bronze layer tables.
    Note: MySQL does not allow LOAD DATA inside stored procedures, so this
    is executed as a direct script.
===============================================================================
NOTE: 
	This script requires 'local_infile' to be enabled on both the 
	server and client side. If execution fails, please refer to the 
	troubleshooting section in the project README.
===============================================================================
Loading Script: Load Bronze Layer
===============================================================================
*/

-- Track Total Pipeline Start Time
SET @pipeline_start = NOW();

SELECT '==================================================' AS ' ';
SELECT 'Loading Bronze Layer' AS ' ';
SELECT '==================================================' AS ' ';

SELECT '---------------------------------------------------------------' AS ' ';
SELECT 'Loading CRM Tables' AS ' ';
SELECT '---------------------------------------------------------------' AS ' ';

-- 1. Load CRM Customer Info
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.crm_cust_info' AS ' ';
TRUNCATE TABLE bronze.crm_cust_info;

SELECT '>> Loading Data Into Table: bronze.crm_cust_info' AS ' ';
SELECT '>> Inserting Data Into: bronze.crm_cust_info' AS ' ';
LOAD DATA LOCAL INFILE 'C:/Users/SKANTECH/OneDrive/Desktop/Data Science Files/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS
(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date);

SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> ---------------' AS ' ';

-- 2. Load CRM Product Info
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.crm_prd_info' AS ' ';
TRUNCATE TABLE bronze.crm_prd_info;

SELECT '>> Loading Data Into Table: bronze.crm_prd_info' AS ' ';
LOAD DATA LOCAL INFILE 'C:/Users/SKANTECH/OneDrive/Desktop/Data Science Files/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'LINES TERMINATED BY '\r\n'IGNORE 1 ROWS
(prd_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt);

SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> ---------------' AS ' ';

-- 3. Load CRM Sales Details
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.crm_sales_details' AS ' ';
TRUNCATE TABLE bronze.crm_sales_details;

SELECT '>> Loading Data Into Table: bronze.crm_sales_details' AS ' ';
LOAD DATA LOCAL INFILE 'C:/Users/SKANTECH/OneDrive/Desktop/Data Science Files/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'LINES TERMINATED BY '\r\n'IGNORE 1 ROWS
(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price);

SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> ---------------' AS ' ';

SELECT '---------------------------------------------------------------' AS ' ';
SELECT 'Loading ERP Tables' AS ' ';
SELECT '---------------------------------------------------------------' AS ' ';

-- 4. Load ERP Customer AZ12
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.erp_cust_az12' AS ' ';
TRUNCATE TABLE bronze.erp_cust_az12;

SELECT '>> Loading Data Into Table: bronze.erp_cust_az12' AS ' ';
SELECT '>> Inserting Data Into: bronze.erp_cust_az12' AS ' ';
LOAD DATA LOCAL INFILE 'C:/Users/SKANTECH/OneDrive/Desktop/Data Science Files/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS
(cid, bdate, gen);

SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> ---------------' AS ' ';

-- 5. Load ERP Location A101
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.erp_loc_a101' AS ' ';
TRUNCATE TABLE bronze.erp_loc_a101;

SELECT '>> Loading Data Into Table: bronze.erp_loc_a101' AS ' ';
LOAD DATA LOCAL INFILE 'C:/Users/SKANTECH/OneDrive/Desktop/Data Science Files/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'LINES TERMINATED BY '\r\n'IGNORE 1 ROWS
(cid, cntry);

SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> ---------------' AS ' ';

-- 6. Load ERP Product Category G1V2
SET @start_time = NOW();
SELECT '>> Truncating Table: bronze.erp_px_cat_g1v2' AS ' ';
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

SELECT '>> Loading Data Into Table: bronze.erp_px_cat_g1v2' AS ' ';
LOAD DATA LOCAL INFILE 'C:/Users/SKANTECH/OneDrive/Desktop/Data Science Files/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'LINES TERMINATED BY '\r\n'IGNORE 1 ROWS
(id, cat, subcat, maintenance);

SET @end_time = NOW();
SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds') AS ' ';
SELECT '>> ---------------' AS ' ';

-- ============================================================================
-- FINAL ASSIGNMENT: Total Load Duration
-- ============================================================================
SET @pipeline_end = NOW();

SELECT '==================================================' AS ' ';
SELECT 'BRONZE LAYER LOADING COMPLETED' AS ' ';
SELECT CONCAT('Total Load Duration: ', TIMESTAMPDIFF(SECOND, @pipeline_start, @pipeline_end), ' seconds') AS ' ';
SELECT '==================================================' AS ' ';
