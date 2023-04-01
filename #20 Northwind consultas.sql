/*1. Respaldo de Base de datos con SQL SERVER*/

--Respaldo Full de Base de Datos

Backup database Northwind
to disk = 'C:\Respaldos BD\Northwind.bak'
With
name = 'Northwind Backup'

--Respaldo Diferencial de Base de Datos

Backup database Northwind
to disk = 'C:\Respaldos BD\Northwind.bak'
With
name = 'Northwind Backup Diferencial', Differential

--Respaldo del Registro de Transacciones

Backup log Northwind
to disk = 'C:\Respaldos BD\Northwind.bak'
With
name = 'Northwind Backup Registro de Transacciones'

/*2. Dispositivo de Almacenamiento*/

--Creaci�n de Dispositivo

use Northwind
go
sp_addumpdevice 'Disk','Respaldo_Adventure','C:\Respaldos BD\Northwind.bak'

--Respaldo utilizando Dispositivo

Backup database Northwind
to Respaldo_Adventure
With
name = 'Northwind Backup'

----------------------------------------------------------

Backup database Northwind
to Respaldo_Adventure
With
name = 'Northwind Backup Diferencial', Differential

----------------------------------------------------------

Backup log Northwind
to Respaldo_Adventure
With
name = 'Northwind Backup Registro de Transacciones'

--Visualizar Dispositivos Existentes

sp_helpdevice

--Borrar Dispositivo

sp_dropdevice 'Respaldo_Adventure'

/*3. Restauraci�n de Base de Datos*/

--Visualizar la lista de respaldo contenidos en el archivo backup

Restore Headeronly
from disk = 'C:\Respaldos BD\Northwind.bak'
----------------------------------------------
-- Utilizando directamente el dispositivo de almacenamiento
Restore Headeronly
from Respaldo_Adventure

--Visualizar los archivos de datos y archivos de registro de transacciones contenido en cada respaldo del archivo backup

Restore Filelistonly
from disk = 'C:\Respaldos BD\Northwind.bak'
with file = 1
--------------------------------------------------
Restore Filelistonly
from Respaldo_Adventure
with file = 1

--Restauraci�n de Base de Datos

Restore database Northwind
from disk = 'C:\Respaldos BD\Northwind.bak'
with file = 1, ------ posici�n del archivo a restaurar
noRecovery
------ En proceso de Restauraci�n

Restore database Northwind
from disk = 'C:\Respaldos BD\Northwind.bak'
with file = 2, ------ posici�n del archivo a restaurar
noRecovery
------ En proceso de Restauraci�n

Restore database Northwind
from disk = 'C:\Respaldos BD\Northwind.bak'
with file = 3, ------ posici�n del archivo a restaurar
Recovery
------ En proceso de Restauraci�n

sp_detach_db Northwind

sp_attach_db Northwind,
'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Northwnd.mdf', 
'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Northwnd.ldf'