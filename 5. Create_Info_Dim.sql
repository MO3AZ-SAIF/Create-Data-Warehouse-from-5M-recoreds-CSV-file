USE SalesDW
GO

-- Create InfoDim
IF NOT EXISTS(SELECT 1 FROM sys.tables WHERE name = 'InfoDim')
BEGIN
	CREATE TABLE InfoDim(
		InfoKey INT PRIMARY KEY IDENTITY(1,1),
		ItemType NVARCHAR(50) NOT NULL,
		SalesChannel NVARCHAR(50) NOT NULL,
		OrderPriority NVARCHAR(1) NOT NULL
	);
END
ELSE
BEGIN
	PRINT('Table is already created!')
END

CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_InfoDim
ON InfoDim(ItemType,SalesChannel,OrderPriority)

-- Populate the Info Dimension Table
INSERT INTO InfoDim(ItemType, SalesChannel, OrderPriority)
SELECT DISTINCT ItemType, SalesChannel, OrderPriority
FROM SourceData
ORDER BY ItemType, SalesChannel, OrderPriority

-- Validate data was inserted into the table
SELECT * FROM InfoDim