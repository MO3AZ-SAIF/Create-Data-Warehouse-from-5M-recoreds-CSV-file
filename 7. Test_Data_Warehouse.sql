USE SalesDW
GO

-- Ensure all dirty pages are written to disk
CHECKPOINT;
-- Clear the buffer cache
DBCC DROPCLEANBUFFERS;

SET STATISTICS TIME ON
SET STATISTICS IO ON

SELECT 
	F.OrderID AS OrderID,
	A.Region AS Region,
	A.Country AS Country,
	I.ItemType AS ItemType,
	I.SalesChannel AS SalesChannel,
	I.OrderPriority AS OrderPriority,
	D1.DateAltKey AS OrderDate,
	D2.DateAltKey AS ShipDate,
	F.UnitsSold AS UnitsSold,
	F.UnitPrice AS UnitPrice,
	F.UnitCost AS UnitCost,
	F.TotalRevenue AS TotalRevenue,
	F.TotalCost AS TotalCost,
	F.TotalProfit AS TotalProfit
FROM SalesFact AS F
JOIN AddressDim AS A ON A.AddressKey = F.AddressKey
JOIN InfoDim AS I ON I.InfoKey = F.InfoKey
JOIN DateDim AS D1 ON D1.DateKey = F.OrderDate
JOIN DateDim AS D2 ON D2.DateKey = F.ShipDate
WHERE D1.YEAR = 2010

SET STATISTICS TIME OFF
SET STATISTICS IO OFF