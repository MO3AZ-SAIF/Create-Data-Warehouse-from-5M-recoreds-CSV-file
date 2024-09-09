USE SalesDW
GO

-- Determine the range
SELECT MIN(OrderDate) , MAX(OrderDate) FROM SourceData
-- 2010-01-01   :   2020-09-10
SELECT MIN(ShipDate) , MAX(ShipDate) FROM SourceData
-- 2010-01-01   :   2020-10-30

-- MIN DATE: 2010-01-01	 - 	MAX DATE: 2020-10-30  -  GRAIN: 1 DAY

-- Create DateDim
IF NOT EXISTS(SELECT 1 FROM sys.tables WHERE name = 'DateDim')
BEGIN
	CREATE TABLE DateDim(
		DateKey INT PRIMARY KEY,
		DateAltKey DATE NOT NULL,
		DayOfWeek INT NOT NULL,
		DayName NVARCHAR(10) NOT NULL,
		DayOfMonth INT NOT NULL,
		Month INT NOT NULL,
		MonthName NVARCHAR(10) NOT NULL,
		Year INT NOT NULL,
	);
END
ELSE
BEGIN
	PRINT('Table is already created!')
END
GO

-- Populate the Date Dimension Table
DECLARE @StartDate DATE = '2010-01-01'
DECLARE @EndDate DATE = '2020-10-30'
DECLARE @LoopDate DATE = @StartDate

WHILE @LoopDate <= @EndDate
BEGIN
	INSERT INTO DateDim(DateKey, DateAltKey, DayOfWeek, DayName, DayOfMonth, Month, MonthName, Year) 
	VALUES(
		CAST(CONVERT(VARCHAR(8),@LoopDate,112) AS INT),
		@LoopDate,
		DATEPART(DW, @LoopDate),
		DATENAME(DW, @LoopDate),
		DAY(@LoopDate),
		MONTH(@LoopDate),
		DATENAME(MM, @LoopDate),
		YEAR(@LoopDate)
	);
	SET @LoopDate = DATEADD(DAY , 1 , @LoopDate)
END
GO

-- Create indexes on frequently queried columns
CREATE NONCLUSTERED INDEX IX_DateDim_Year ON DateDim(Year);
CREATE NONCLUSTERED INDEX IX_DateDim_DateAltKey ON DateDim(DateAltKey);

-- Validate data was inserted into the table
SELECT * FROM DateDim