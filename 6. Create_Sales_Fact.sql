USE SalesDW
GO

-- Create and Insert Data Into Sales Fact Table
SELECT 
	S.OrderID AS OrderID,
	A.AddressKey AS AddressKey,
	I.InfoKey AS InfoKey,
	D1.DateKey AS OrderDate,
	D2.DateKey AS ShipDate,
	S.UnitsSold AS UnitsSold,
	S.UnitPrice AS UnitPrice,
	S.UnitCost AS UnitCost,
	S.TotalRevenue AS TotalRevenue,
	S.TotalCost AS TotalCost,
	S.TotalProfit AS TotalProfit
INTO SalesFact
FROM SourceData AS S
JOIN AddressDim AS A
ON S.Region = A.Region AND S.Country = A.Country
JOIN InfoDim AS I
ON S.ItemType = I.ItemType AND S.SalesChannel = I.SalesChannel AND S.OrderPriority = I.OrderPriority 
JOIN DateDim AS D1
ON S.OrderDate = D1.DateAltKey
JOIN DateDim AS D2
ON S.ShipDate = D2.DateAltKey


-- Creating a Clustered Columnstore Index on a Fact Table
CREATE CLUSTERED COLUMNSTORE INDEX CCI_SalesFact ON SalesFact 

-- Creating foreign keys on a Fact table
IF NOT EXISTS( SELECT 1 FROM sys.foreign_keys WHERE name = 'fk_AddressDim' )
BEGIN
	ALTER TABLE SalesFact
	ADD CONSTRAINT fk_AddressDim FOREIGN KEY (AddressKey) REFERENCES AddressDim(AddressKey)
END

IF NOT EXISTS( SELECT 1 FROM sys.foreign_keys WHERE name = 'fk_InfoDim' )
BEGIN
	ALTER TABLE SalesFact
	ADD CONSTRAINT fk_InfoDim FOREIGN KEY (InfoKey) REFERENCES InfoDim(InfoKey)
END

IF NOT EXISTS( SELECT 1 FROM sys.foreign_keys WHERE name = 'fk_OrderDate' )
BEGIN
	ALTER TABLE SalesFact
	ADD CONSTRAINT fk_OrderDate FOREIGN KEY (OrderDate) REFERENCES DateDim(DateKey)
END

IF NOT EXISTS( SELECT 1 FROM sys.foreign_keys WHERE name = 'fk_ShipDate' )
BEGIN
	ALTER TABLE SalesFact
	ADD CONSTRAINT fk_ShipDate FOREIGN KEY (ShipDate) REFERENCES DateDim(DateKey)
END

-- Validate data was inserted into the table
SELECT * FROM SalesFact