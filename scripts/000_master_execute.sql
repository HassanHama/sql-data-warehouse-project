/*
===============================================================================
Master Deployment Script
===============================================================================
Script Purpose:
    This script orchestrates the entire Build-up of the Data Warehouse.
    It executes all scripts in the correct sequence to ensure proper 
    dependency management.
    
Usage:
    Run this script to completely rebuild the Data Warehouse from scratch.
===============================================================================
*/

-- 1. Setup the Environment (Databases)
-- This must run first to create the bronze, silver, and gold containers.
SOURCE scripts/init_database.sql;

-- 2. Build and Load the Bronze Layer
-- This creates the tables (DDL) and then loads the data using LOAD DATA LOCAL INFILE.
SOURCE scripts/bronze/ddl_bronze.sql;
SOURCE scripts/bronze/load_bronze.sql;

-- 3. Build and Load the Silver Layer
-- First, we build the "containers" (Tables)
SOURCE scripts/silver/ddl_silver.sql; 

-- Second, we define the "cleaning logic" (Stored Procedure)
SOURCE scripts/silver/proc_load_silver.sql;

-- Finally, we execute the logic to move data from Bronze to Silver
CALL silver.load_silver();

-- Execute Quality Audits from the separate tests folder
SELECT '>> Running Silver Layer Data Quality Tests...' AS message;
SOURCE tests/test_silver.sql;

-- 4. Build and Load the Gold Layer
-- SOURCE scripts/gold/proc_load_gold.sql;
-- CALL gold.load_gold();

SELECT 'Data Warehouse Build Completed Successfully!' AS status;
