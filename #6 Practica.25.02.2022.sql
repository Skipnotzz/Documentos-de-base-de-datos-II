SELECT Name , StandardCost , Color FROM Production.Product

SELECT * FROM Production.Product

SELECT ProductID,Name,Color,StandardCost,ListPrice FROM Production.Product

SELECT ProductID, Color,StandardCost,ListPrice
FROM Production.Product inner JOIN Production.ProductModel
ON
Production.Product.ProductModelID =Production.ProductModel.ProductModelID

select *from Production.ProductModel

select productid, Production.Product.Name, color, Standardcost, ListPrice, Production.ProductModel.ProductModelID,
Production.ProductModel.Name
from Production.Product
inner join Production.ProductModel
on production.Product.ProductModelID=Production.ProductModel.ProductModelID

select Production.Product.ProductID, 
Production.Product.name as product ,
Production.product.color,
Production.Product.StandardCost,
Production.Product.ListPrice,
Production.ProductModel.ProductModelID,
Production.ProductModel.NAME as model
from Production.Product INNER JOIN Production.ProductModel ON
Production.Product.ProductModelID =Production.ProductModel.ProductModelID

SELECT AdventureWorks2019.Production.Product.ProductID
FROM AdventureWorks2019.Production.Product

SELECT * FROM SYS.servers

/*---------------------------------------01 de febrero del 2022---------------------------------------------*/

USE AdventureWorks2019
GO

CREATE TABLE dbo.SlateGravel(

	LastName VARCHAR (25) NULL,
	FirstName VARCHAR (25) NULL,
	Position VARCHAR (25)
	
);

INSERT SlateGravel VALUES ('Flintstone', 'Fred', 'Bronto Driver'), ('Rubble','Barney','Accountant'),
('Turley', 'Paul', 'Developer'), ('Wood','Dan','DBA'), ('Rockhead','Don','System Administrator'),
('Rockstone','Pauline','Manager')

SELECT * FROM SlateGravel

SELECT * FROM SlateGravel
	WHERE LastName LIKE 'Flint%'

SELECT * FROM SlateGravel
	WHERE LastName LIKE '%stone'

SELECT * FROM SlateGravel
	WHERE LastName LIKE '%sto%'

SELECT * FROM SlateGravel
	WHERE LastName LIKE '_urley'

SELECT * FROM SlateGravel
	WHERE FirstName LIKE 'D[ao]n'

SELECT * FROM SlateGravel
	WHERE FirstName LIKE 'D[a-o]n'

SELECT * FROM SlateGravel
	WHERE FirstName LIKE 'D[^o]n'

SELECT * FROM SlateGravel
	WHERE FirstName NOT LIKE 'Dan'

SELECT ProductID , NAME , ListPrice FROM Production.Product
	WHERE ProductSubCategoryID = 1 AND ListPrice < 1000

SELECT ProductID , Name , ListPrice FROM Production.Product
	WHERE ProductSubCategoryID = 1 OR ListPrice < 1000

SELECT ProductID , Name , ListPrice FROM production.Product
	WHERE NOT ProductSubCategoryID = 2

SELECT ProductID , Name , Color FROM Production.Product
	WHERE Color IS NULL

SELECT ProductID , Name , Color FROM Production.Product
	WHERE Color IS NOT NULL

/*El operador BETWEEN*/

SELECT NationalIDNumber , LoginID FROM HumanResources.Employee 
	WHERE BirthDate > = '1962 1 1' AND BirthDate < = '1985 12 31'

SELECT NationalIDNumber , LoginID FROM HumanResources.Employee
	WHERE BirthDate BETWEEN '1962 1 1' AND '1985 12 31'

/*La función IN*/

SELECT ProductID, Name AS Product FROM Production.Product
	WHERE ProductSubCategoryID = 1 OR ProductSubCategoryID = 2 
	OR ProductSubCategoryID = 3

SELECT ProductID,  Name AS Product FROM Production.Product
	WHERE ProductSubCategoryID IN (1,2,3)

/*PRACTICA 3.6c: Ejecutar la siguiente consulta que recupera todos
los productos cuyos ProductCategoryID son 1 ó 2. Como la tabla
de productos solo contiene sub categorias se debe hacer una
sub consulta a la tabla de categoría.*/

SELECT ProductID , Name AS Product FROM Production.Product
	WHERE ProductSubCategoryID IN 
		(SELECT ProductSubCategoryID FROM Production.ProductSubCategory WHERE ProductCategoryID IN (1,2))

/*Verificar que la siguiente consulta
genera una lista de bicicletas
montañeras y bicicleta de carretera
con precios mayores de $500 y
menores de $1000*/

SELECT Name, ProductNumber, ListPrice, ProductSubCategoryID FROM Production.Product
	WHERE ProductSubCategoryID = 1 OR ProductSubCategoryID = 2 AND
	ListPrice > 500 AND ListPrice < 1000

/*PRÁCTICA 3.8: Ejecutar las siguientes
consultas y analizar los resultados*/

/*1*/
SELECT Name AS Product, ListPrice, StandardCost FROM Production.Product
	WHERE ListPrice > 0
		ORDER BY ListPrice DESC, StandardCost

/*2*/
SELECT SalesOrderID , ProductID, UnitPrice * OrderQty AS PurchasePrice FROM Sales.SalesOrderDetail
	ORDER BY UnitPrice * OrderQty

/*3*/
SELECT SalesOrderID , ProductID,UnitPrice * OrderQty AS PurchasePrice FROM Sales.SalesOrderDetail
	ORDER BY PurchasePrice

/*PRÁCTICA 3.9: Ejecutar las
siguientes consultas y analizar los
resultados*/

/*1*/
SELECT TOP 10 Name, ListPrice FROM Production.Product
	ORDER BY ListPrice DESC

/*2*/
SELECT TOP 10 WITH TIES Name, ListPrice FROM Production.Product
	ORDER BY ListPrice DESC

/*3*/
SELECT TOP 10 PERCENT Name, ListPrice FROM Production.Product
	ORDER BY ListPrice DESC

/*PRÁCTICA 3.10a: Ejecutar la siguiente
consulta y analizar los resultados*/
SELECT ProductNumber, Category = 
	CASE ProductLine WHEN 'R' THEN 'Road' 
	WHEN 'M' THEN 'Mountain' 
	WHEN 'T' THEN 'Touring' 
	WHEN 'S' THEN 'Other sale items' 
	ELSE 'Not for sale' END ,Name
FROM Production.Product ORDER BY ProductNumber

SELECT ProductNumber ,Name,'Price Range' = CASE WHEN ListPrice = 0 THEN 'Mfg item not for resale'
WHEN ListPrice < 50 THEN 'Under 50' WHEN ListPrice >= 50 and ListPrice < 250 THEN 'Under 250'
WHEN ListPrice >=250 and ListPrice < 1000 THEN 'Under 1000' ELSE 'Over 1000' END FROM Production.Product ORDER BY ProductNumber