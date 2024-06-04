--Ex1
SELECT 
	t1.ProductID, 
	t1.Name,
	t1.Color,
	t1.ListPrice,
	t1.Size
FROM Production.Product t1
LEFT JOIN Sales.SalesOrderDetail t2
ON t1.ProductID = t2.ProductID
WHERE t2.ProductID IS NULL
ORDER BY ProductID;

--Ex2
SELECT 
	t1.CustomerID, 
	COALESCE(t2.LastName, 'Unknown') AS LastName,
	COALESCE(t2.FirstName, 'Unknown') AS FirstName
FROM Sales.Customer t1
LEFT JOIN Person.Person t2
ON t1.CustomerID=t2.BusinessEntityID
LEFT JOIN Sales.SalesOrderHeader t3
ON t1.CustomerID = t3.CustomerID
WHERE t3.CustomerID IS NULL
ORDER BY t1.CustomerID;

--Ex3
SELECT 
	CustomerID,
	FirstName,
	LastName,
	CountOfOrders
FROM (SELECT
		ROW_NUMBER() OVER (ORDER BY COUNT(SalesOrderID) DESC) AS RN,
		t1.CustomerID AS CustomerID, 
		t3.FirstName AS FirstName,
		t3.LastName AS LastName,
		COUNT(SalesOrderID) AS CountOfOrders
	 FROM Sales.SalesOrderHeader t1
	 LEFT JOIN Sales.Customer t2
	 ON t1.CustomerID=t2.CustomerID
	 LEFT JOIN Person.Person t3
	 ON t2.PersonID=t3.BusinessEntityID
	 GROUP BY t1.CustomerID, t3.FirstName,t3.LastName
	 )tt
WHERE RN<=10;

--Ex4
SELECT
	t2.FirstName,
	t2.LastName,
	t1.JobTitle,
	t1.HireDate,
	COUNT(t1.BusinessEntityID) OVER(PARTITION BY t1.JobTitle ORDER BY t1.JobTitle) AS CountOfTitle
FROM HumanResources.Employee t1
LEFT JOIN Person.Person t2
ON t1.BusinessEntityID=t2.BusinessEntityID;

--Ex5
SELECT 
		SalesOrderID,
		CustomerID,
		LastName,
		FirstName,
		LastOrder,
		PreviousOrder
FROM (SELECT 
			t2.SalesOrderID AS SalesOrderID,
			t1.CustomerID AS CustomerID,
			t3.LastName AS LastName,
			t3.FirstName AS FirstName,
			OrderDate AS LastOrder,
			LAG(OrderDate) OVER (PARTITION BY t1.CustomerID ORDER BY t2.SalesOrderID) AS PreviousOrder,
			RANK() OVER(PARTITION BY t1.CustomerID ORDER BY OrderDate DESC) AS RNK
		FROM Sales.Customer t1
		LEFT JOIN Sales.SalesOrderHeader t2
		ON t1.CustomerID=t2.CustomerID
		INNER JOIN Person.Person t3
		ON t1.PersonID=t3.BusinessEntityID
		)tt
WHERE 1=1
AND RNK=1;

--Ex6
SELECT 
	Year,
	SalesOrderID,
	LastName,
	FirstName,
	Total
FROM (SELECT
		YEAR(t1.OrderDate) Year,
		t1.SalesOrderID AS SalesOrderID,
		LastName,
		FirstName,
		SUM(LineTotal) AS Total,
		DENSE_RANK() OVER(PARTITION BY YEAR(t1.OrderDate) ORDER BY SUM(LineTotal) DESC) AS DRNK
	FROM Sales.SalesOrderHeader t1
	LEFT JOIN Sales.Customer t2
	ON t1.CustomerID=t2.CustomerID
	LEFT JOIN Person.Person t3
	ON t2.PersonID=t3.BusinessEntityID
	LEFT JOIN Sales.SalesOrderDetail t4
	ON t1.SalesOrderID=t4.SalesOrderID
	GROUP BY Year(t1.OrderDate), t1.SalesOrderID, LastName, FirstName
	)tt
WHERE 1=1
AND DRNK=1;

--Ex7
SELECT Month,
	   [2011], 
	   [2012], 
	   [2013], 
	   [2014]
	   
FROM (SELECT 
		MONTH(OrderDate) AS Month,
		YEAR(OrderDate) AS Year,
		COUNT(SalesOrderID) OVER(PARTITION BY MONTH(OrderDate) ORDER BY MONTH(OrderDate)) AS Counter_a
	 FROM Sales.SalesOrderHeader
	 ) src
PIVOT(
		COUNT(Counter_a)
		FOR Year IN ([2011], [2012], [2013], [2014])
	  )pvt
ORDER BY Month;

--Ex8
SELECT 
	Year,
	Month,
	Sum_Price,
	CumSum
FROM (SELECT 
		YEAR(OrderDate)AS Year,
		CONVERT(VARCHAR, MONTH(OrderDate)) AS Month,
		SUM(UnitPrice) AS Sum_Price,
		SUM(SUM(UnitPrice)) OVER( PARTITION BY YEAR(OrderDate) ORDER BY YEAR(OrderDate),
		CAST(MONTH(OrderDate) AS INT) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumSum,
		ROW_NUMBER() OVER(PARTITION BY YEAR(OrderDate) ORDER BY CAST(MONTH(OrderDate) AS INT))AS RNK
	FROM Sales.SalesOrderHeader t1 
	LEFT JOIN Sales.SalesOrderDetail t2
	ON t1.SalesOrderID = t2.SalesOrderID
	GROUP BY GROUPING SETS ((YEAR(OrderDate), CAST(MONTH(OrderDate) AS INT)))
	UNION
	SELECT 
		YEAR(OrderDate),
		'grand_total',
		NULL,
		SUM(UnitPrice),
		13
	FROM Sales.SalesOrderHeader t1 
	LEFT JOIN Sales.SalesOrderDetail t2
	ON t1.SalesOrderID = t2.SalesOrderID
	GROUP BY YEAR(OrderDate)
	)tt
ORDER BY Year, RNK;

--Ex9
SELECT t0.*,
		ABS(DATEDIFF(DAY,HireDate,PreviuseEmpDate)) AS DiffDays
FROM
	(SELECT tt.*,
			LEAD("Employee'sFullName") OVER(PARTITION BY DepartmentName ORDER BY HireDate DESC) AS PreviuseEmpName,
			LEAD(HireDate) OVER(PARTITION BY DepartmentName ORDER BY HireDate DESC) AS PreviuseEmpDate
	FROM(SELECT
			t1.Name AS DepartmentName,
			t3.BusinessEntityID AS "Employee'sID",
			FirstName+ ' ' + LastName AS "Employee'sFullName",
			HireDate,
			DATEDIFF(MONTH, HireDate, GETDATE()) AS Seniority
		FROM HumanResources.Department t1
		LEFT JOIN HumanResources.EmployeeDepartmentHistory t2
		ON t1.DepartmentID=t2.DepartmentID
		LEFT JOIN HumanResources.Employee t3
		ON t2.BusinessEntityID=t3.BusinessEntityID
		LEFT JOIN Person.Person t4
		ON t3.BusinessEntityID=t4.BusinessEntityID
		)tt
	)t0;


--Ex10
SELECT 
	HireDate,
	DepartmentID,
	STRING_AGG(CONCAT(t2.BusinessEntityID,' ', LastName,' ', FirstName), ', ') AS TeamEmployees
FROM 
	HumanResources.EmployeeDepartmentHistory t1
	LEFT JOIN HumanResources.Employee t2
	ON t1.BusinessEntityID=t2.BusinessEntityID
	LEFT JOIN Person.Person t3
	ON t2.BusinessEntityID=t3.BusinessEntityID
	WHERE 1=1
	AND EndDate IS NULL
GROUP BY HireDate, DepartmentID
ORDER BY HireDate DESC;
