/*
=====================================================
Create Databases (Medallion Architecture)
=====================================================
Script Purpose:
    This script creates three separate databases: 'bronze', 'silver', and 'gold'.
    In MySQL, these serve as the distinct layers of the Data Warehouse.
    If any of these databases already exist, they are dropped and recreated.
    
WARNING:
    Running this script will drop the 'bronze', 'silver', and 'gold' databases.
    All data in these databases will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/

-- Drop the databases if they already exist
DROP DATABASE IF EXISTS bronze;
DROP DATABASE IF EXISTS silver;
DROP DATABASE IF EXISTS gold;

-- Create the databases to represent the warehouse layers
CREATE DATABASE bronze;
CREATE DATABASE silver;
CREATE DATABASE gold;

-- Display the current databases to verify creation
SHOW DATABASES;
