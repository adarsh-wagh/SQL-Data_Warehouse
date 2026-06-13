/*
_______________________________________________________________________________________
Creating Dtabase And Schemas
_______________________________________________________________________________________
Script purpose:
	--Creates a New Database called "DataWarehouse" after checking if it already exists.
	--If a Database called "DataWarehouse" already exists, It is Dropped and Re-Created.
	--Creates three Schemas called "bronze","silver", and "gold"
_______________________________________________________________________________________
*/


USE MASTER;
GO

--drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

--creating the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO


USE DataWarehouse;
GO

--creating schemas
CREATE SCHEMA bronze;
GO


CREATE SCHEMA silver;
GO


CREATE SCHEMA gold;
GO
