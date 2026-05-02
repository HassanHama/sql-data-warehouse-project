/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' database to mirror the raw 
    source data from CRM and ERP systems.
    Each table includes a technical metadata column 'dwh_load_date'.
===============================================================================
*/

USE bronze;

-- 1. CRM Customer Info
DROP TABLE IF EXISTS crm_cust_info;
CREATE TABLE crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr           VARCHAR(50),
    cst_create_date    DATE,
    dwh_load_date      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. CRM Product Info
DROP TABLE IF EXISTS crm_prd_info;
CREATE TABLE crm_prd_info (
    prd_id             INT,
    prd_key            VARCHAR(50),
    prd_nm             VARCHAR(50),
    prd_cost           INT,
    prd_line           VARCHAR(50),
    prd_start_dt       DATETIME,
    prd_end_dt         DATETIME,
    dwh_load_date      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. CRM Sales Details
DROP TABLE IF EXISTS crm_sales_details;
CREATE TABLE crm_sales_details (
    sls_ord_num        VARCHAR(50),
    sls_prd_key        VARCHAR(50),
    sls_cust_id        INT,
    sls_order_dt       INT,
    sls_ship_dt        INT,
    sls_due_dt         INT,
    sls_sales          INT,
    sls_quantity       INT,
    sls_price          INT,
    dwh_load_date      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. ERP Location A101
DROP TABLE IF EXISTS erp_loc_a101;
CREATE TABLE erp_loc_a101 (
    cid                VARCHAR(50),
    cntry              VARCHAR(50),
    dwh_load_date      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. ERP Customer AZ12
DROP TABLE IF EXISTS erp_cust_az12;
CREATE TABLE erp_cust_az12 (
    cid                VARCHAR(50),
    bdate              DATE,
    gen                VARCHAR(50),
    dwh_load_date      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. ERP Product Category G1V2
DROP TABLE IF EXISTS erp_px_cat_g1v2;
CREATE TABLE erp_px_cat_g1v2 (
    id                 VARCHAR(50),
    cat                VARCHAR(50),
    subcat             VARCHAR(50),
    maintenance        VARCHAR(50),
    dwh_load_date      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
