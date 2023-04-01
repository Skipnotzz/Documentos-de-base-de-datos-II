/*Clase practica*/

/*1- Escriba una consulta de regrese los registros de empleados de
AdventureWorks. Incluya las columnas NationalIDNumber, LoginID, JobTitle,
BirthDate, MaritalStatus, y HireDate en el resultado. Ejecutar la consulta y vea los
resultados.*/

SELECT NationalIDNumber, LoginID, JobTitle, BirthDate, MaritalStatus, HireDate 
	FROM HumanResources.Employee

/*2- Modificar el ejercicio 3.1 para añadir una nueva columna
AgeAtHire, la cual es el resultado de la diferencia entre las columnas HireDate y
BirthDate. (Pista: utilice la función DATEDIFF)*/

SELECT DATEDIFF(YEAR, BirthDate, HireDate) AS 'Duration'
	FROM HumanResources.Employee 

/*3- Regrese todos los registros de Product en la tabla
[Production.Product] en AdventureWorks que tiene 3 días o más para su
producción. Incluya el nombre [Name] y el precio de lista [ListPrice]*/

SELECT NAME, ListPrice, DaysToManufacture 
	FROM Production.Product 
		WHERE DaysToManufacture < 3
			ORDER BY DaysToManufacture

/*4- Regrese una lista de los 10 productos más caros de la tabla
[Production.Product] en AdventureWorks que tiene un número de producto
comenzando con “BK”. Incluya solamente las columnas [ProductID], [Name],
[ProductNumber], [Color], y [ListPrice]. Cuando termine, revise si existe algún
otro producto con el mismo precio que el decimo producto en la lista.*/

--------------------------------------------------------------
SELECT TOP(10)ProductID, NAME, ProductNumber, COLOR, ListPrice 
	FROM Production.Product 
		WHERE (NAME LIKE ('%B')) OR (NAME LIKE ('%K'))
--------------------------------------------------------------
--------------------------------------------------------------
SELECT TOP (10) ProductID, Name, ProductNumber, Color, ListPrice 
	FROM Production.Product 
		WHERE ProductNumber LIKE 'BK%'
			ORDER BY ListPrice DESC
--------------------------------------------------------------

/*5 Recuperar todas las líneas y columnas de la
tabla [ProductSubcategory] y hacer las modificaciones que se
solicitan:*/

SELECT * FROM Production.ProductSubcategory

/*1. Obtenga todas las filas y columnas en la tabla [ProductSubcategory].*/

SELECT * FROM Production.ProductSubcategory

/*2. Modifique la consulta para mostrar solo las columnas:
[ProductSubcategoryID], [ProductCategoryID], [Name] y
[ModifiedDate]*/

SELECT ProductSubcategoryID, ProductCategoryID, Name, ModifiedDate 	
	FROM Production.ProductSubcategory

/*3. Modifique la consulta para mostrar solo las filas donde “bike” esta
en alguna parte de la columna [Name]*/

SELECT Name 
	FROM Production.ProductSubcategory
		WHERE Name LIKE 'bike%'

/*4. Modifique la consulta para agregar un alias a las columna [Name]*/

SELECT Name AS "Nuevo consulta"
	FROM Production.ProductSubcategory
		WHERE Name LIKE 'bike%'

/*5. Modifique la consulta para ordenar el resultado por el nombre de la
sub-categoria (columna Name)*/

SELECT * FROM Production.ProductSubcategory
	ORDER BY ProductSubcategoryID

/*6- Obtenga las ordenes puestas en Junio 2014. (Tablas:
SalesSalesOrderHeader)*/

SELECT * FROM SALES.SalesOrderHeader
	WHERE OrderDate = '2014-06-01'

/*7- Obtenga las ordenes puestas en el último día del mes. (Tablas: Sales.
SalesOrderHeader)*/ 

SELECT * FROM SALES.SalesOrderHeader
	WHERE OrderDate = '2014-06-30'

/*8- Obtenga los empleados cuyo apellido (LastName) contienen la letra
'a' tres veces o más. (Tablas: Person.Contact)*/

SELECT LastName 
	FROM Person.Person
			WHERE LastName LIKE '%a%a%a%'

/*9- Encuentre la instrucción SELECT que regresa para cada empleado el
sexo basado en su titulo (Title). Por ejemplo 'Ms.' y 'Mrs.' regresa 'Female'; para
'Mr' regresa 'Male'; y para cualquier otro caso (por ejemplo Dr.) regresar
'Unknown'. Mostrar el ID, Nombre, Apellido, Titulo y Sexo. (Tablas:
Person.Contact)*/

SELECT Employee.BusinessEntityID, Person.FirstName, Person.LastName, Person.Title, Employee.Gender 
	FROM HumanResources.Employee INNER JOIN Person.Person 
		ON Employee.BusinessEntityID = Person.BusinessEntityID
			WHERE Title LIKE 'M[r-s].'
				ORDER BY Gender

/*10- En el ejercicio anterior ordene los resultados por el titulo, pero 
teniendo los NULL ordenados al final. Note que el orden por defecto pone los 
NULL al principio o sea antes de los valores NOT NULL. (Tablas: Person.Contact)*/