/*
===============================================================================
DDL Script: Create Silver Tables with Enhanced Metadata
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema to store cleansed 
    and standardized data from the Bronze layer.
    
    Added Metadata for Traceability (per README.md):
    - source_system: Identifies the origin (CRM or ERP).
    - file_location: For auditability back to the raw source.
    - dwh_create_date: Records when the record first entered the warehouse.
    - dwh_update_date: Records the latest modification timestamp.
===============================================================================
*/

-- Create schema if it doesn't exist (MySQL specific)
CREATE DATABASE IF NOT EXISTS silver;
USE silver;

-- 1. CRM Customer Info
DROP TABLE IF EXISTS silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr           VARCHAR(50),
    cst_create_date    DATE,
    -- Metadata
    source_system      VARCHAR(50) DEFAULT 'CRM',
    file_location      VARCHAR(255),
    dwh_create_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dwh_update_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. CRM Product Info
DROP TABLE IF EXISTS silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
    prd_id             INT,
    cat_id             VARCHAR(50),
    prd_key            VARCHAR(50),
    prd_nm             VARCHAR(50),
    prd_cost           INT,
    prd_line           VARCHAR(50),
    prd_start_dt       DATE,
    prd_end_dt         DATE,
    -- Metadata
    source_system      VARCHAR(50) DEFAULT 'CRM',
    file_location      VARCHAR(255),
    dwh_create_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dwh_update_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 3. CRM Sales Details
DROP TABLE IF EXISTS silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    sls_ord_num        VARCHAR(50),
    sls_prd_key        VARCHAR(50),
    sls_cust_id        INT,
    sls_order_dt       DATE,
    sls_ship_dt        DATE,
    sls_due_dt         DATE,
    sls_sales          INT,
    sls_quantity       INT,
    sls_price          INT,
    -- Metadata
    source_system      VARCHAR(50) DEFAULT 'CRM',
    file_location      VARCHAR(255),
    dwh_create_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dwh_update_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 4. ERP Customer AZ12 
DROP TABLE IF EXISTS silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
    cid                VARCHAR(50),
    bdate              DATE,
    gen                VARCHAR(50),
    -- Metadata
    source_system      VARCHAR(50) DEFAULT 'ERP',
    file_location      VARCHAR(255),
    dwh_create_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dwh_update_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 5. ERP Location A101
DROP TABLE IF EXISTS silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
    cid                VARCHAR(50),
    cntry              VARCHAR(50),
    -- Metadata
    source_system      VARCHAR(50) DEFAULT 'ERP',
    file_location      VARCHAR(255),
    dwh_create_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dwh_update_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 6. ERP Product Category G1V2
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
    id                 VARCHAR(50),
    cat                VARCHAR(50),
    subcat             VARCHAR(50),
    maintenance        VARCHAR(50),
    -- Metadata
    source_system      VARCHAR(50) DEFAULT 'ERP',
    file_location      VARCHAR(255),
    dwh_create_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dwh_update_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
