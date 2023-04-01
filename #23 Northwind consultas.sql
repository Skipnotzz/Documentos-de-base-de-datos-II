--Respaldo Full de Base de Datos

Backup database Northwind
to disk = 'C:\Respaldos BD\Northwind.bak'
With name = 'Respado Full'

Select * from Region
Insert into Region values (5,'Centro américa')

--Respaldo Diferencial de Base de Datos

Backup database Northwind
to disk = 'C:\Respaldos BD\Northwind.bak'
With name = 'Respaldo Diferencial 1', Differential

Insert into Region values (6,'Sur américa')
Insert into Region values (7,'Norte américa')

Backup database Northwind
to disk = 'C:\Respaldos BD\Northwind.bak'
With name = 'Respaldo Diferencial 2', Differential

Insert into Region values (8,'Región central')
Insert into Region values (9,'Ecuador')

Backup database Northwind
to disk = 'C:\Respaldos BD\Northwind.bak'
With name = 'Respaldo Diferencial 3', Differential

Insert into Region values (10,'Polo sur')

Backup database Northwind
to disk = 'C:\Respaldos BD\Northwind.bak'
With name = 'Respaldo Diferencial 4', Differential

Insert into Region values (11,'Polo norte')

--Respaldo del Registro de Transacciones

Backup log Northwind
to disk = 'C:\Respaldos BD\Northwind.bak'
With name = 'Respaldo Log 1'

select * from Region

Insert into Region values (12,'Oceania')

Backup database Northwind
to disk = 'C:\Respaldos BD\Northwind.bak'
With name = 'Respaldo Diferencial 5', Differential

restore filelistonly
from disk = 'C:\Respaldos BD\Northwind.bak'

Drop database Northwind

Restore database Northwind
from disk = 'C:\Respaldos BD\Northwind.bak'
with file = 1,
norecovery

Restore database Northwind
from disk = 'C:\Respaldos BD\Northwind.bak'
with file = 2,
norecovery

Restore database Northwind
from disk = 'C:\Respaldos BD\Northwind.bak'
with file = 3,
norecovery

Restore database Northwind
from disk = 'C:\Respaldos BD\Northwind.bak'
with file = 4,
norecovery

Restore database Northwind
from disk = 'C:\Respaldos BD\Northwind.bak'
with file = 5,
norecovery

Restore database Northwind
from disk = 'C:\Respaldos BD\Northwind.bak'
with file = 6,
norecovery

Restore database Northwind
from disk = 'C:\Respaldos BD\Northwind.bak'
with file = 7

use Northwind
go
select *from 