
Delete from DimCliente
Delete from DimEmpleado
Delete from DimEmpresaEnvio
Delete from DimFecha
Delete from FactOrdenes
---------------------------------------------
DBCC CHECKIDENT (DimFecha, RESEED,0)
DBCC CHECKIDENT (DimCliente, RESEED,0)
DBCC CHECKIDENT (DimEmpleado, RESEED,0)
DBCC CHECKIDENT (DimEmpresaEnvio, RESEED,0)
DBCC CHECKIDENT (Factordenes, RESEED,0)
------------------------------------------------------
Select * from DimCliente
Select * from DimEmpleado
Select * from DimEmpresaEnvio
Select * from DimFecha 
Select * from FactOrdenes 
--------------------------------------------------------
-- Carga de Tabla de Hechos
-------------------------------------------------------------
Merge dbo.FactOrdenes Destino
Using
(Select 
df.DimfechaID as DimFechaID,
de.DimEmployeeID as DimEmployeeID,
dc.DimCustomerID as DimCustomerID,
ee.DimShipperID as DimShipperID,
count(Distinct o.OrderID) as Cantidad,
round (sum(od.Quantity * od.UnitPrice),2) as SinDescuento,
round (sum((od.Quantity * od.UnitPrice)- (od.Quantity * od.UnitPrice * od.Discount)),2) as Recaudacion
from Northwind.dbo.Orders o
inner join Northwind.dbo.[Order Details] od
on od.OrderID = o.OrderID
inner join DimFecha df
on df.IdFecha = o.OrderDate
inner join DimEmpleado de
on de.EmployeeID = o.EmployeeID
inner join DimCliente dc
on dc.CustomerID = o.CustomerID
inner join DimEmpresaEnvio ee
on ee.ShipperID = o.ShipVia
WHERE de.FechaFinal='9999/12/31' AND 
	  dc.FechaFinal='9999/12/31' AND 
	  ee.FechaFinal='9999/12/31' 
Group by
df.DimFechaID,
de.DimEmployeeID,
dc.DimCustomerID ,
ee.DimShipperID) Origen
on
Destino.DimCustomerID = Origen.DimCustomerID and
Destino.DimEmployeeID = Origen.DimEmployeeID and
Destino.DimShipperID = Origen.DimShipperID and
Destino.DimFechaID = Origen.DimFechaID
WHEN MATCHED AND (Destino.Cantidad <> Origen.Cantidad or
                  Destino.Sindescuento <> Origen.SinDescuento or
				  Destino.Recaudacion <> Origen.Recaudacion)
				  Then
				  Update set
				  Destino.Cantidad = Origen.Cantidad,
                  Destino.Sindescuento = Origen.SinDescuento,
				  Destino.Recaudacion = Origen.Recaudacion
WHEN NOT MATCHED THEN 
            INSERT
			(DimFechaID, DimEmployeeID, DimCustomerID, DimShipperID,
			 Cantidad, SinDescuento, Recaudacion)
			 Values
			 (Origen.DimFechaID,Origen.DimEmployeeID, Origen.DimCustomerID,
			 Origen.DimShipperID,Origen.Cantidad, Origen.SinDescuento, Origen.Recaudacion);