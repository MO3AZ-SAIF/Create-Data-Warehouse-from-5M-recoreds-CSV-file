USE SalesDW
GO

-- Create AddressDim
IF NOT EXISTS(SELECT 1 FROM sys.tables WHERE name = 'AddressDim')
BEGIN
	CREATE TABLE AddressDim(
		AddressKey INT PRIMARY KEY IDENTITY(1,1),
		Region NVARCHAR(50) NOT NULL,
		Country NVARCHAR(50) NOT NULL
	);
END
ELSE
BEGIN
	PRINT('Table is already created!')
END


-- Populate the Address Dimension Table
INSERT INTO AddressDim(Region,Country)
SELECT DISTINCT Region, Country 
FROM SourceData
ORDER BY Region, Country 


-- Validate data was inserted into the table
SELECT * FROM AddressDim