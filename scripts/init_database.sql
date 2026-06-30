/* 
======================================
create database and schemas
======================================
 Scripts purpose:
  This script creates a new database named datawarehousde after checkung if it already exists.
  If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
Warning:
Running this script will drop the entire 'datawarehouse database if it already exists 
ensure proper backups
*/
USE master;
GO -- GO HELPS TO RUN THE COMMAND FIRST THEN MOVE TO SOME OTHER 

IF EXISTS (SELECT 1 FROM sys.databases WHERE name ='DataWarehouse') -- Check for the existance of DataWarehouse in sys.database
BEGIN  -- if true then run
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE; -- allow only one user to access database 
	DROP DATABASE DataWarehouse; -- drop data 
END;
GO

CREATE DATABASE DataWarehouse;
GO 
use DataWarehouse;
Go
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
