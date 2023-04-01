sp_attach_db AdventureWorks,
'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AdventureWorks2019.mdf', 
'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AdventureWorks2019_Log.ldf'

--C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA

--Respaldo Full de Base de Datos

BACKUP DATABASE AdventureWorks
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\AdventureWorks_prueba.bak'
WITH
NAME = 'AdventureWorks2019 Backup'

--Respaldo Diferencial de Base de Datos

Backup database AdventureWorks
to disk = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\AdventureWorks_prueba.bak'
With
name = 'AdventureWorks2012 Backup Diferencial', Differential

--Respaldo del Registro de Transacciones

Backup log AdventureWorks
to disk = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\AdventureWorks_prueba.bak'
With
name = 'AdventureWorks2012 Backup Registro de Transacciones'

--opciones, full

/*Dispositivo de Almacenamiento*/

--Creación de Dispositivo

use AdventureWorks
go
sp_addumpdevice 'Disk','Respaldo_Adventures','C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\AdventureWorks_prueba.bak'

--Respaldo utilizando Dispositivo

Backup database AdventureWorks
to Respaldo_Adventures
With
name = 'AdventureWorks2012 Backup'

Backup database AdventureWorks
to Respaldo_Adventures
With
name = 'AdventureWorks2012 Backup Diferencial', Differential

Backup log AdventureWorks
to Respaldo_Adventures
With
name = 'AdventureWorks2012 Backup Registro de Transacciones'

--Visualizar Dispositivos Existentes

sp_helpdevice

--Borrar Dispositivo

sp_dropdevice 'Respaldo_Adventures'

/*Restauración de Base de Datos*/

Restore Headeronly
from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\AdventureWorks_prueba.bak'
----------------------------------------------
-- Utilizando directamente el dispositivo de almacenamiento
Restore Headeronly
from Respaldo_Adventures