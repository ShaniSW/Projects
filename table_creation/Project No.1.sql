USE AdventureWorks2019
GO

--Table1--

CREATE TABLE Sales.CreditCard1(
	CreditCardID INT PRIMARY KEY NOT NULL,
	CardType NVARCHAR(255) NOT NULL,
	CardNumber NVARCHAR(255) NOT NULL,
	ExpMonth TINYINT NOT NULL,
	ExpYear SMALLINT NOT NULL,
	ModifiedDate DATETIME NOT NULL DEFAULT getdate()
);

INSERT INTO sales.CreditCard1 
SELECT * FROM sales.CreditCard
--Check if OK
--SELECT * FROM sales.CreditCard1

--Table2--

CREATE TABLE Purchasing.ShipMethod1(
	ShipMethodID INT PRIMARY KEY NOT NULL,
	[Name] NAME NOT NULL,
	ShipBase MONEY NOT NULL DEFAULT (0.00),
	ShipRate MONEY NOT NULL DEFAULT (0.00),
	rowguid NVARCHAR(255) NOT NULL DEFAULT newid(),
	ModifiedDate DATETIME NOT NULL DEFAULT getdate()
);

INSERT INTO Purchasing.ShipMethod1 
SELECT * FROM Purchasing.ShipMethod
--Check if OK
--SELECT * FROM Purchasing.ShipMethod

--Table3--
--Create a table as DBA--

CREATE TABLE Sales.SpecialOfferProduct1(
	SpecialOfferID INT FOREIGN KEY REFERENCES Sales.SpecialOffer(SpecialOfferID) NOT NULL,
	ProductID INT FOREIGN KEY REFERENCES Production.Product(ProductID) NOT NULL,
	rowguid NVARCHAR(255) NOT NULL DEFAULT newid(),
	ModifiedDate DATETIME NOT NULL DEFAULT getdate()
	CONSTRAINT PK_SpecialOfferProduct1_SpecialOfferID_ProductID PRIMARY KEY (SpecialOfferID, ProductID)
);

--בתור מי שמייצר את הטבלה, בהמשך ניתן יהיה להשתמש בשם החדש של 
	--הPK עבור Alter Table 
	--וליצור שינויים רצויים 

INSERT INTO Sales.SpecialOfferProduct1 
SELECT * FROM Sales.SpecialOfferProduct
--Check if OK
--SELECT * FROM Sales.SpecialOfferProduct1

--Create a table as Data Analyst--

--CREATE TABLE Sales.SpecialOfferProduct1(
	--SpecialOfferID INT PRIMARY KEY (SpecialOfferID,ProductID) FOREIGN KEY REFERENCES Sales.SpecialOffer(SpecialOfferID) NOT NULL,
	--ProductID INT FOREIGN KEY REFERENCES Production.Product(ProductID) NOT NULL,
	--rowguid NVARCHAR(255) NOT NULL DEFAULT newid(),
	--ModifiedDate DATETIME NOT NULL DEFAULT getdate()
--);

--בתור אנליסט, כותבים את הPK בהתחלה עם אזכור של שני השדות בסוגריים
--בשורה השניה מגדירים רק FK כיוון שה-PK הוגדר בשורה הראשונה
--המנוע של SQL יודע לשייף את השדה השני, למרות שכביכול "טרם הוקם" כי הוא שני בסדר, כחלק מה-PK

--Table4--

CREATE TABLE Person.Address1 (
	AddressID INT PRIMARY KEY NOT NULL,
	AddressLine1 NVARCHAR(255) NOT NULL,
	AddressLine2 NVARCHAR(255) NULL,
	City NVARCHAR(255) NOT NULL,
	StateProvinceID INT FOREIGN KEY REFERENCES Person.StateProvince(StateProvinceID) NOT NULL,
	PostalCode NVARCHAR(255) NOT NULL,
	SpatialLocation GEOGRAPHY NULL,
	rowguid NVARCHAR(255) NOT NULL DEFAULT newid(),
	ModifiedDate DATETIME NOT NULL DEFAULT getdate()
) ;

INSERT INTO Person.Address1 
SELECT * FROM Person.Address
--Check if OK
--SELECT * FROM Person.Address1

--Table5--

CREATE TABLE Sales.CurrencyRate1 (
	CurrencyRateID INT PRIMARY KEY NOT NULL,
	CurrencyRateDate DATETIME NOT NULL,
	FromCurrencyCode NCHAR(3) FOREIGN KEY REFERENCES Sales.Currency(CurrencyCode) NOT NULL,
	ToCurrencyCode NCHAR(3) FOREIGN KEY REFERENCES Sales.Currency(CurrencyCode) NOT NULL,
	AverageRate MONEY NOT NULL,
	EndOfDayRate MONEY NOT NULL,
	ModifiedDate DATETIME NOT NULL DEFAULT getdate()
) ;

INSERT INTO Sales.CurrencyRate1
SELECT * FROM Sales.CurrencyRate
--Check if OK
--SELECT * FROM Sales.CurrencyRate1

--Table6--

CREATE TABLE Sales.SalesTerritory1(
	TerritoryID INT PRIMARY KEY NOT NULL,
	[Name] NAME NOT NULL,
	CountryRegionCode NVARCHAR(3) FOREIGN KEY REFERENCES Person.CountryRegion(CountryRegionCode) NOT NULL,
	[Group] NVARCHAR(255) NOT NULL,
	SalesYTD MONEY NOT NULL,
	SalesLastYear MONEY NOT NULL,
	CostYTD MONEY NOT NULL,
	CostLastYear MONEY NOT NULL,
	rowguid NVARCHAR(255) NOT NULL DEFAULT newid(),
	ModifiedDate DATETIME NOT NULL DEFAULT getdate()
) ;

INSERT INTO Sales.SalesTerritory1
SELECT * FROM Sales.SalesTerritory
--Check if OK
--SELECT * FROM Sales.SalesTerritory1

--Table7--

CREATE TABLE Sales.Customer1 (
	CustomerID INT PRIMARY KEY NOT NULL,
	PersonID INT FOREIGN KEY REFERENCES Person.Person(BusinessEntityID) NULL,
	StoreID INT FOREIGN KEY REFERENCES Sales.Store(BusinessEntityID) NULL,
	TerritoryID INT FOREIGN KEY REFERENCES Sales.SalesTerritory1(TerritoryID) NULL,
	AccountNumber VARCHAR(10) NOT NULL,
	rowguid NVARCHAR(255) NOT NULL DEFAULT newid(),
	ModifiedDate DATETIME NOT NULL DEFAULT getdate()
) ;

INSERT INTO Sales.Customer1
SELECT * FROM Sales.Customer
--Check if OK
SELECT * FROM Sales.Customer1

--Table8--

CREATE TABLE Sales.SalesPerson1(
	BusinessEntityID INT PRIMARY KEY FOREIGN KEY REFERENCES HumanResources.Employee(BusinessEntityID) NOT NULL,
	TerritoryID INT FOREIGN KEY REFERENCES Sales.SalesTerritory1(TerritoryID) NULL,
	SalesQuota MONEY NULL,
	Bonus MONEY NOT NULL,
	CommissionPct SMALLMONEY NOT NULL,
	SalesYTD MONEY NOT NULL,
	SalesLastYear MONEY NOT NULL,
	rowguid NVARCHAR(255) NOT NULL DEFAULT newid(),
	ModifiedDate DATETIME NOT NULL DEFAULT getdate()
);

INSERT INTO Sales.SalesPerson1
SELECT * FROM Sales.SalesPerson
--Check if OK
SELECT * FROM Sales.SalesPerson1

--Table9--

CREATE TABLE Sales.SalesOrderHeader1(
	SalesOrderID INT PRIMARY KEY NOT NULL,
	RevisionNumber TINYINT NOT NULL,
	OrderDate DATETIME NOT NULL,
	DueDate DATETIME NOT NULL,
	ShipDate DATETIME NOT NULL,
	[Status] TINYINT NOT NULL,
	OnlineOrderFlag INT NOT NULL,
	SalesOrderNumber NVARCHAR(255) NOT NULL,
	PurchaseOrderNumber NVARCHAR(255) NULL,
	AccountNumber NVARCHAR(255) NULL,
	CustomerID INT FOREIGN KEY REFERENCES Sales.Customer1(CustomerID) NOT NULL,
	SalesPersonID INT FOREIGN KEY REFERENCES Sales.SalesPerson1(BusinessEntityID) NULL,
	TerritoryID INT FOREIGN KEY REFERENCES Sales.SalesTerritory1(TerritoryID) NULL,
	BillToAddressID INT FOREIGN KEY REFERENCES Person.Address1(AddressID) NOT NULL,
	ShipToAddressID INT FOREIGN KEY REFERENCES Person.Address1(AddressID) NOT NULL,
	ShipMethodID INT FOREIGN KEY REFERENCES Purchasing.ShipMethod1(ShipMethodID) NOT NULL,
	CreditCardID INT FOREIGN KEY REFERENCES Sales.CreditCard1(CreditCardID) NULL,
	CreditCardApprovalCode VARCHAR(15) NULL,
	CurrencyRateID INT FOREIGN KEY REFERENCES Sales.CurrencyRate1(CurrencyRateID) NULL,
	SubTotal MONEY NOT NULL,
	TaxAmt MONEY NOT NULL,
	Freight MONEY NOT NULL,
	TotalDue MONEY NOT NULL,
	Comment NVARCHAR(255) NULL,
	rowguid NVARCHAR(255) NOT NULL DEFAULT newid(),
	ModifiedDate DATETIME NOT NULL DEFAULT getdate()
);

INSERT INTO Sales.SalesOrderHeader1
SELECT * FROM Sales.SalesOrderHeader
--Check if OK
SELECT * FROM Sales.SalesOrderHeader1

--Table10--

CREATE TABLE Sales.SalesOrderDetail1(
	SalesOrderID INT PRIMARY KEY (SalesOrderID,SalesOrderDetailID) FOREIGN KEY REFERENCES Sales.SalesOrderHeader1(SalesOrderID) NOT NULL,
	SalesOrderDetailID INT NOT NULL,
	CarrierTrackingNumber NVARCHAR(255) NULL,
	OrderQty SMALLINT NOT NULL,
	ProductID INT FOREIGN KEY REFERENCES Production.Product(ProductID) NOT NULL,
	SpecialOfferID INT FOREIGN KEY REFERENCES Sales.SpecialOffer(SpecialOfferID) NOT NULL,
	UnitPrice MONEY NOT NULL,
	UnitPriceDiscount MONEY NOT NULL,
	LineTotal INT NOT NULL,
	rowguid NVARCHAR(255) NOT NULL DEFAULT newid(),
	ModifiedDate DATETIME NOT NULL DEFAULT getdate()
);

INSERT INTO Sales.SalesOrderDetail1
SELECT * FROM Sales.SalesOrderDetail
--Check if OK
SELECT * FROM Sales.SalesOrderDetail1

--לא ניתן להפנות FK ל-PK מאוחד, לכן יש להפנות ל-PK שהוגדר בטבלת המקור.
--אנחנו נדרשים להפנות FK לשדה המוגדר באופן בלתי תלוי 
--כ-PK בטבלת המקור.  
-- אנו למדים ששדה שמוגדר כ-PK יחד עד שדה אחר, הוא לא PK בפני עצמו










