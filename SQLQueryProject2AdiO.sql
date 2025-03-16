
-----שאלה 1

WITH TotalSalesByYears 
AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        SUM(UnitPrice * PickedQuantity) AS IncomePerYear,
        COUNT(DISTINCT MONTH(OrderDate)) AS NumberOfDistinctMonths
    FROM SALES.Orders O JOIN SALES.OrderLines L 
	ON O.OrderID = L.OrderID
    GROUP BY YEAR(OrderDate)
),
YearlyLinearIncome AS (
    SELECT 
        Year,
        IncomePerYear,
        NumberOfDistinctMonths,
        (IncomePerYear / NumberOfDistinctMonths) * 12 AS YearlyLinearIncome,  -- התאמה להכנסה השנתית לפי מספר החודשים
        LAG((IncomePerYear / NumberOfDistinctMonths) * 12) OVER (ORDER BY Year) AS PreviousYearLinearIncome
    FROM TotalSalesByYears
)
SELECT 
    Y.Year,
    Y.IncomePerYear,
    Y.NumberOfDistinctMonths,
    Y.YearlyLinearIncome,
    CASE 
        WHEN Y.PreviousYearLinearIncome IS NOT NULL AND Y.PreviousYearLinearIncome > 0 
            THEN CAST(FLOOR(((Y.YearlyLinearIncome - Y.PreviousYearLinearIncome) / Y.PreviousYearLinearIncome) * 100*100)/100  AS FLOAT)
        ELSE NULL
    END AS GrowthRate
FROM YearlyLinearIncome Y
ORDER BY Y.Year

GO


---שאלה 2

WITH TOP5CLIENTS AS (
    SELECT 
        YEAR(O.OrderDate) AS TheYear,   
        DATEPART(QUARTER, O.OrderDate) AS TheQuarter,
        C.CustomerName AS CustomerName,
        SUM(G.UnitPrice * G.Quantity) AS IncomePerYear
    FROM sales.Customers C 
    JOIN SALES.Orders O ON C.CustomerID = O.CustomerID
    LEFT JOIN Sales.OrderLines G ON G.OrderID = O.OrderID
    GROUP BY 
        C.CustomerName,
        YEAR(O.OrderDate),
        DATEPART(QUARTER, O.OrderDate)
),

DNRANK AS (
    SELECT 
        CustomerName,
        TheYear,
        IncomePerYear,
        TheQuarter,
        ROW_NUMBER() OVER (PARTITION BY TheYear, TheQuarter ORDER BY IncomePerYear DESC) AS DNR
    FROM TOP5CLIENTS
)

SELECT TheYear ,TheQuarter, CustomerName,IncomePerYear
    
    
FROM DNRANK
WHERE DNR <= 5
ORDER BY TheYear, TheQuarter, DNR

GO
----שאלה 3

SELECT TOP 10
    OL.StockItemID,
    P.Description,
    CAST(SUM(OL.ExtendedPrice - OL.TaxAmount) AS FLOAT) AS TotalProfit
FROM Sales.InvoiceLines OL JOIN  Sales.InvoiceLines P 
ON OL.InvoiceID = P.InvoiceID
GROUP BY OL.StockItemID, P.Description 
ORDER BY TotalProfit DESC

GO

----שאלה 4

SELECT 
    StockItemID,
    StockItemName,
    RecommendedRetailPrice,
    UnitPrice,
    (RecommendedRetailPrice - UnitPrice) AS NominalProductProfit,
    RANK() OVER (ORDER BY (RecommendedRetailPrice - UnitPrice) DESC) AS DNR
FROM Warehouse.StockItems
ORDER BY NominalProductProfit DESC

GO

-----שאלה 5

SELECT
    CONCAT(S.SupplierID, '-', S.SupplierName) AS SupplierDetails,
    STUFF((
        SELECT ' / ' + CONCAT(P.StockItemID, '-', P.StockItemName)
        FROM Warehouse.StockItems P
        WHERE P.SupplierID = S.SupplierID
          AND ISNULL(P.StockItemID, '') <> ''
          AND ISNULL(P.StockItemName, '') <> ''
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 3, '') AS ProductDetails
FROM purchasing.Suppliers S
WHERE EXISTS (
    SELECT 1
    FROM Warehouse.StockItems P
    WHERE P.SupplierID = S.SupplierID
      AND ISNULL(P.StockItemID, '') <> ''
      AND ISNULL(P.StockItemName, '') <> ''
)
GROUP BY S.SupplierID, S.SupplierName
ORDER BY S.SupplierID




GO

----שאלה 6

SELECT TOP 5
    CU.CustomerID,
    C.CityName,
    CO.CountryName,
    CO.Continent,
    CO.Region,
   FORMAT( CAST(SUM(IVL.ExtendedPrice) AS float),'N2') AS TotalExtendedPrice
FROM Sales.Customers CU JOIN Application.Cities C 
	ON CU.DeliveryCityID = C.CityID
JOIN Application.StateProvinces SP  ON C.StateProvinceID = SP.StateProvinceID
JOIN Application.Countries CO ON SP.CountryID = CO.CountryID
JOIN Sales.Invoices INV ON CU.CustomerID = INV.CustomerID
JOIN Sales.InvoiceLines IVL ON INV.InvoiceID = IVL.InvoiceID
GROUP BY 
    CU.CustomerID,
    CU.CustomerName,
    C.CityName,
    SP.StateProvinceName,
    CO.CountryName,
    CO.Continent,
    CO.Region
ORDER BY 

   SUM(IVL.ExtendedPrice) DESC
GO

----שאלה 7 

WITH MonthlyData AS (
    SELECT 
        YEAR(O.OrderDate) AS OrderYear,
        MONTH(O.OrderDate) AS OrderMonth,
        SUM(OL.PickedQuantity * OL.UnitPrice) AS MonthlyTotal,
        SUM(SUM(OL.PickedQuantity * OL.UnitPrice)) OVER (PARTITION BY YEAR(O.OrderDate) ORDER BY MONTH(O.OrderDate)) AS CumulativeTotal
    FROM Sales.Orders O JOIN Sales.Orderlines OL 
        ON O.OrderID = OL.OrderID
    GROUP BY YEAR(O.OrderDate), MONTH(O.OrderDate)
),

YearlyTotal AS (
    SELECT 
        OrderYear,
        'GrandTotal' AS OrderMonth,
        SUM(MonthlyTotal) AS MonthlyTotal,
        SUM(MonthlyTotal) AS CumulativeTotal,
        13 AS MonthOrder
    FROM MonthlyData
    GROUP BY OrderYear

),

CombinedData AS (
    SELECT 
        OrderYear,
        CAST(OrderMonth AS VARCHAR) AS OrderMonth,
        FORMAT(MonthlyTotal, 'N2') AS MonthlyTotal,
        FORMAT(CumulativeTotal, 'N2') AS CumulativeTotal,
        CASE 
            WHEN ISNUMERIC(OrderMonth) = 1 THEN CAST(OrderMonth AS INT)
            ELSE 13
        END AS MonthOrder
    FROM MonthlyData

    UNION ALL

    SELECT 
        OrderYear,
        OrderMonth,
        FORMAT(MonthlyTotal, 'N2') AS MonthlyTotal,
        FORMAT(CumulativeTotal, 'N2') AS CumulativeTotal,
        MonthOrder
    FROM YearlyTotal
)


SELECT 
    OrderYear,
    OrderMonth,
    MonthlyTotal,
    CumulativeTotal
FROM CombinedData
ORDER BY 
    OrderYear,
    MonthOrder

GO

----שאלה 8 

SELECT 
    OrderMonth,
    ISNULL([2013], 0) AS [2013],
    ISNULL([2014], 0) AS [2014],
    ISNULL([2015], 0) AS [2015],
	ISNULL([2016], 0) AS [2016]
FROM (
    SELECT 
        YEAR(O.OrderDate) AS OrderYear,
        MONTH(O.OrderDate) AS OrderMonth,
        COUNT(O.OrderID) AS OrderCount
    FROM Sales.Orders O
    GROUP BY YEAR(O.OrderDate), MONTH(O.OrderDate)
) AS SourceTable
PIVOT (
    SUM(OrderCount)
    FOR OrderYear IN ([2013], [2014], [2015] ,[2016])
) AS PivotTable
ORDER BY OrderMonth

GO 

-----שאלה 9

WITH OrderInfo AS (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        o.OrderDate,
        LAG(o.OrderDate) OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS PreviousOrderDate,
        MAX(o.OrderDate) OVER (PARTITION BY c.CustomerID) AS LastOrderDate,
        MAX(o.OrderDate) OVER () AS AllOrderLastDate
    FROM Sales.Customers c
    JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
)
SELECT
    CustomerID,
    CustomerName,
    OrderDate,
    PreviousOrderDate,
 
    DATEDIFF(DAY, LastOrderDate, AllOrderLastDate) AS DaysSinceLastOrder,
    AVG(DATEDIFF(DAY, PreviousOrderDate, OrderDate)) OVER (PARTITION BY CustomerID) AS AvgDaysBetweenOrders,
    CASE
        WHEN DATEDIFF(DAY, LastOrderDate, AllOrderLastDate) > 
             2 * AVG(DATEDIFF(DAY, PreviousOrderDate, OrderDate)) OVER (PARTITION BY CustomerID)
        THEN 'Potential Churn'
        ELSE 'Active'
    END AS CustomerStatus
FROM OrderInfo
ORDER BY CustomerID

GO

----שאלה 10 

WITH CustomerCategories AS (
    SELECT     
      DISTINCT CC.CustomerCategoryName,
        CASE 
            WHEN C.CustomerName LIKE '%Tailspin%' THEN 'Tailspin'
            WHEN C.CustomerName LIKE '%Wingtip%' THEN 'Wingtip'
            ELSE C.CustomerName
        END AS Adidush_Store1
     FROM Sales.Customers C 
    JOIN Sales.CustomerCategories CC  ON CC.CustomerCategoryID = C.CustomerCategoryID

),

CustomerCategoryCounts AS (
    SELECT 
    CustomerCategoryName, 
	
        COUNT(Adidush_Store1)AS CustomerCOUNT 
     FROM CustomerCategories 
    GROUP BY   CustomerCategoryName
),

SumCustomerCount AS (
    SELECT 
        SUM(CustomerCOUNT) AS TotalCustCount
      FROM CustomerCategoryCounts
)

SELECT 
    TCC.CustomerCategoryName,
    TCC.CustomerCOUNT,
    SCC.TotalCustCount,
    CONCAT(FORMAT((TCC.CustomerCOUNT * 1.0 / SCC.TotalCustCount) * 100, 'N2'), '%') AS DistributionFactor
 FROM SumCustomerCount SCC CROSS JOIN CustomerCategoryCounts TCC
