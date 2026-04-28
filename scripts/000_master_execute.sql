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
-- These will be created as we progress through the video.
-- SOURCE scripts/bronze/proc_load_bronze.sql;
-- CALL bronze.load_bronze();

-- 3. Build and Load the Silver Layer
-- SOURCE scripts/silver/proc_load_silver.sql;
-- CALL silver.load_silver();

-- 4. Build and Load the Gold Layer
-- SOURCE scripts/gold/proc_load_gold.sql;
-- CALL gold.load_gold();

SELECT 'Data Warehouse Build Completed Successfully!' AS status;
