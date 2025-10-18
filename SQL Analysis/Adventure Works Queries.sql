--1. Overall Performance Summary: Get a quick overview of total financial performance
SELECT 
    SUM(Sales) as TotalSales,
    SUM(Sales - Cost) as NetProfit,
    (SUM(Sales - Cost) / SUM(Sales)) * 100 as ProfitMargin,
    COUNT(DISTINCT SalesOrderNumber) as TotalOrders
FROM Sales


--2. Sales Performance by Region: Analyze which geographic areas generate the most revenue
SELECT 
    r.Region,
    SUM(s.Sales) as TotalSales,
    COUNT(DISTINCT s.SalesOrderNumber) as OrderCount
FROM Sales s
JOIN Region r ON s.SalesTerritoryKey = r.SalesTerritoryKey
GROUP BY r.Region
ORDER BY TotalSales DESC


--3.Top 10 Salespeople by Revenue: Identify the highest-performing sales team members
SELECT TOP 10
    sp.Salesperson,
    sp.Title,
    SUM(s.Sales) AS TotalSales,
    COUNT(DISTINCT s.SalesOrderNumber) AS OrderCount
FROM Sales s
JOIN Salesperson sp ON s.EmployeeKey = sp.EmployeeKey
GROUP BY sp.Salesperson, sp.Title
ORDER BY TotalSales DESC


--4. Top 10 Best-Selling Products: Discover which products generate the most revenue
SELECT TOP 10
    p.Product,
    p.Category,
    p.Subcategory,
    SUM(s.Sales) AS TotalSales,
    SUM(s.Quantity) AS TotalQuantity
FROM Sales s
JOIN Product p ON s.ProductKey = p.ProductKey
GROUP BY p.Product, p.Category, p.Subcategory
ORDER BY TotalSales DESC


--5. Reseller Analysis by Business Type: Understand which reseller types perform best
SELECT 
    res.Business_Type,
    COUNT(DISTINCT res.Reseller) AS ResellerCount,
    SUM(s.Sales) AS TotalSales,
    ROUND(AVG(s.Sales), 2) AS AvgSalesPerReseller
FROM Sales s
JOIN Reseller res ON s.ResellerKey = res.ResellerKey
GROUP BY res.Business_Type
ORDER BY TotalSales DESC


--6. Monthly Sales Trend Analysis: Track sales performance over time
SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    DATENAME(MONTH, OrderDate) AS MonthName,
    SUM(Sales) AS MonthlySales,
    COUNT(DISTINCT SalesOrderNumber) AS MonthlyOrders
FROM Sales
GROUP BY YEAR(OrderDate), MONTH(OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY YEAR, MonthlySales


--7. Sales Target Achievement: Compare actual sales performance against targets
SELECT 
    sp.Salesperson,
    SUM(s.Sales) AS ActualSales,
    t.Target AS MonthlyTarget,
    ROUND((SUM(s.Sales) / t.Target) * 100, 1) AS AchievementPercent
FROM Sales s
JOIN Salesperson sp ON s.EmployeeKey = sp.EmployeeKey
JOIN Targets t ON sp.EmployeeID = t.EmployeeID
GROUP BY sp.Salesperson, t.Target
ORDER BY AchievementPercent DESC


--8. Product Quantity Analysis: Analyze sales volume by product category
SELECT 
    p.Category,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Sales) AS TotalSales,
    ROUND(SUM(s.Sales) / SUM(s.Quantity), 2) AS AvgPricePerUnit
FROM Sales s
JOIN Product p ON s.ProductKey = p.ProductKey
GROUP BY p.Category
ORDER BY TotalQuantity DESC


--9. Reseller Order Frequency: Identify most active resellers
SELECT TOP 5
    res.Reseller,
    res.Business_Type,
    res.City,
    COUNT(DISTINCT s.SalesOrderNumber) AS OrderCount,
    SUM(s.Sales) AS TotalSales
FROM Sales s
JOIN Reseller res ON s.ResellerKey = res.ResellerKey
GROUP BY res.Reseller, res.Business_Type, res.City
HAVING COUNT(DISTINCT s.SalesOrderNumber) >= 5
ORDER BY OrderCount DESC


--10. Weekly Sales Patterns: Identify busiest days of the week
SELECT 
    DATENAME(WEEKDAY, OrderDate) AS DayOfWeek,
    SUM(Sales) AS TotalSales,
    COUNT(DISTINCT SalesOrderNumber) AS OrderCount
FROM Sales
GROUP BY DATENAME(WEEKDAY, OrderDate)
ORDER BY TotalSales DESC;