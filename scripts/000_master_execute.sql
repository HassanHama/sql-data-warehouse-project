/*
===============================================================================
Master Deployment Script
===============================================================================
Script Purpose:
    This script orchestrates the entire Build-up of the Data Warehouse.
    It executes all scripts in the correct sequence to ensure proper 
    dependency management.
===============================================================================
*/

-- 1. Setup the Environment (Databases)
-- Located in the same directory (scripts/)
SOURCE init_database.sql;

-- 2. Build and Load the Bronze Layer
-- Located in sub-directories of scripts/
SOURCE bronze/ddl_bronze.sql;
SOURCE bronze/load_bronze.sql;

-- 3. Build and Load the Silver Layer
-- 3.1. Build the Table Structures (DDL)
SOURCE silver/ddl_silver.sql; 

-- 3.2. Define the Transformation Logic (Stored Procedure)
SOURCE silver/proc_load_silver.sql;

-- 3.3. Execute the Load Process
CALL silver.load_silver();

-- 3.4. Execute Quality Audits (Silver)
-- Note: '..' moves up from scripts/ to the root, then into tests/
SELECT '>> Running Silver Layer Data Quality Tests...' AS message;
SOURCE ../tests/test_silver.sql; 

-- 4. Build and Load the Gold Layer
-- 4.1. Build the Business Views (DDL)
SELECT '>> Building Gold Layer Views...' AS message;
SOURCE gold/ddl_gold.sql;

-- 4.2. Run Quality Audits (Gold)
SELECT '>> Running Gold Layer Data Quality Tests...' AS message;
SOURCE ../tests/test_gold.sql;

-- Finish
SELECT 'Data Warehouse Build Completed Successfully!' AS status;
