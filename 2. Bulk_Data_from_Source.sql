USE SalesDW
GO

-- Create Source Data Table
IF NOT EXISTS( SELECT 1 FROM sys.tables WHERE name = 'SourceData' )
BEGIN
	CREATE TABLE SourceData(
		Region NVARCHAR(50) NOT NULL,
		Country NVARCHAR(50) NOT NULL,
		ItemType NVARCHAR(50) NOT NULL,
		SalesChannel NVARCHAR(50) NOT NULL,
		OrderPriority NVARCHAR(1) NOT NULL,
		OrderDate DATE NOT NULL,
		OrderID INT NOT NULL,
		ShipDate DATE NOT NULL,
		UnitsSold INT NOT NULL,
		UnitPrice DECIMAL(10,2) NOT NULL,
		UnitCost DECIMAL(10,2) NOT NULL,
		TotalRevenue DECIMAL(10,2) NOT NULL,
		TotalCost DECIMAL(10,2) NOT NULL,
		TotalProfit DECIMAL(10,2) NOT NULL
	);
END
ELSE 
BEGIN
	PRINT('Table is already created!')
END

-- Insert Data to Source 
BULK INSERT SourceData
FROM 'D:\Courses\Projects\Project 3 - Beginner - Create Data Warehouse from 5M recoreds CSV file\5m Sales Records.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    ERRORFILE = 'D:\Courses\Projects\Project 3 - Beginner - Create Data Warehouse from 5M recoreds CSV file\ErrorLog.txt'
);
GO

-- Validate data was inserted into the table
SELECT TOP(100) * FROM SourceData