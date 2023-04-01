Use Northwind
go
-- Dimensión de Fechas
Create view DimFechas
as
Select distinct Orderdate as IDFecha,
                YEAR(Orderdate) as Año,
				MONTH(Orderdate) as NoMes,
				DATENAME(month, Orderdate) as NombreMes,
				day(orderdate) as NoDia,
				Datename(weekday, orderdate) as NombreDia,
				DATEPART(QQ, orderdate) as Trimestre
 from Orders o
 GO
 -- Dimensión del Cliente
 Create View DimCustomers
 as
 Select 
 CustomerID, CompanyName, ContactName, City, Country From Customers
 GO
 -- Dimensión del Empleado
 Alter view DimEmployees
 as
 Select EmployeeID, Firstname, Lastname, City, Country, Region,BirthDate 
 from Employees
 GO

 Create view DimShippers
 as	
 Select   S.ShipperID,
          S.CompanyName,
		  S.Phone
 from Shippers S
 GO
 -- conformación de Tabla de Hechos

 Select * from Orders


  Create view HechosOrdenes
  as
  Select 
  c.CustomerID,
  e.EmployeeID,
  s.ShipperID,
  Orderdate,
  COUNT(distinct o.OrderID) as Cantidad,
  round (sum(((od.UnitPrice * od.Quantity) - (od.unitPrice* od.Quantity*od.Discount)) * 0.15),2)
       as Impuesto,
  round(sum(od.UnitPrice * od.Quantity * od.Discount),2) as Descuento,
  o.Freight as [Cargo Envío],
  round(sum(od.UnitPrice * od.Quantity),2) as [SubTotal sin Impuesto],
  round (sum(((od.UnitPrice * od.Quantity) - (od.unitPrice* od.Quantity*od.Discount)) * 1.15),2)
       as Total
  from [Order Details] od
  inner join Orders o
  on o.OrderID = od.OrderID
  inner join Employees e
  on e.EmployeeID = o.EmployeeID
  inner join Customers c
  on c.CustomerID = o.CustomerID
  inner join Shippers s
  on s.ShipperID = o.ShipVia
  Group by  o.Freight,  o.orderID, c.CustomerID,
  e.EmployeeID,
  s.ShipperID,
  Orderdate
  Select * from HechosOrdenes
  GO

  

