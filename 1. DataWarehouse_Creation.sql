-- Create Date Warehouse
IF NOT EXISTS ( SELECT 1 FROM sys.databases WHERE name = 'SalesDW' )
BEGIN
	CREATE DATABASE SalesDW
END
ELSE
BEGIN
	PRINT('DATABASE ALREADY CREATED!')
END
GO

ALTER DATABASE SalesDW
SET RECOVERY BULK_LOGGED;
GO

USE SalesDW
GO