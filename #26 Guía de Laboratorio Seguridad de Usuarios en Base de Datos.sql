/*Creaci�n de Cuenta SQL y Cuenta Windows:*/

Create login Acceso with password = 'sistemas123' -- Creaci�n de Cuenta SQL 
Create login [DESKTOP-2JGMS0L\Admin] from Windows -- Creaci�n de Cuenta de Windows donde
-- servidor es el dominio y UNI la cuenta de Windows

Create user Juan from login Acceso

/*Ejercicio 1: En este escenario crearemos un inicio de sesi�n llamado �Sistema�, d�ndole permiso de conexi�n en la 
BD Northwind, le daremos permiso de lectura, escritura y actualizado en todas las tablas.*/

--1. Crear una cuenta de SQL.

Create login Sistema with password = 'sistemas123'

--2. Crear un Usuario en la BD Northwind llamado �Digitador� y asignarlo a la cuenta de acceso Sistema.

use Northwind 
go 
Create User Digitador from Login Sistema

--3. Permiso de Lectura, escritura y actualizado en todas las tablas.

Grant select, insert, update on Database:: Northwind to Digitador

--4. Acceda con la cuenta Sistema y verifique los permisos concedidos.

SELECT * FROM Region

INSERT INTO Region(RegionID,RegionDescription)
VALUES ('5','Verificar el nuevo registro')

SELECT * FROM Region

UPDATE Region SET RegionDescription ='Southern actulizado' WHERE RegionID = 4

SELECT * FROM Region

/*Ejercicio 2: En este escenario revocaremos los permisos concedidos en el Ejercicio guiado 1 
y solamente le daremos permiso de lectura en la tabla: Customers y Orders*/

--1. Revocando los permisos concedidos:

Revoke select, insert, update 
on Database:: Northwind to Digitador

SELECT * FROM Categories

--2. Asignando los nuevos permisos:

Grant select on Customers to Digitador 
Grant select on Orders to Digitador

--Otra forma de plantearlo:

Grant select on Object::Customers to Digitador 
Grant select on Object:: Orders to Digitador

--3. Para verificar los permisos del usuario en la BD.
use Northwind 
go 
sp_helprotect null, Digitador

--4. Resultado de la consola al ejecutar el procedimiento sp_helprotect

/*Ejercicio 3: Siguiendo el escenario del ejercicio anterior, le daremos permisos 
de actualizaci�n en la tabla empleado.*/

--1. Permiso de Actualizaci�n en la tabla Empleado

Grant update on Employees to Digitador

--2. Ingrese con la Cuenta Sistema al gestor y ejecute la siguiente actualizaci�n en la tabla Employees:

use Northwind
go
update Employees set Country = 'Nicaragua' where EmployeeID = 2

--3. La herramienta mandar� el siguiente error:

/*Esto se debe porque no tiene permiso de selecci�n en la tabla Employees, esto le impide ejecutar 
el comando where para realizar el filtro y actualizar el registro, para que finalmente pueda ejecutarlo 
entonces se le debe conceder el permiso de selecci�n.*/

--4. Concediendo permiso de selecci�n en la tabla Employees:

Grant select on Employees to Digitador

--5. Ejecutar nuevamente la instrucci�n de actualizado.

use Northwind 
go 
update Employees set Country = 'Nicaragua' where EmployeeID = 2

--6. Confirmaci�n de dato actualizado desde la consola de la cuenta Sistema.

/*Ejercicio 4: Siguiendo el escenario del ejercicio anterior, conc�dale permisos 
de ejecuci�n en el procedimiento almacenado: [dbo].[CustOrderHist] y las vistas 
[dbo].[Category Sales for 1997], [dbo].[Order Details Extended]*/

--1. Permiso en el procedimiento almacenado:

Grant execute on [dbo].[CustOrderHist] to Digitador

--2. Permiso en las vistas:

Grant select on [dbo].[Category Sales for 1997] to Digitador 
Grant select on [dbo].[Order Details Extended] to Digitador
go
--3. Revisar los permisos concedidos desde la consola de la cuenta sistema. Puede realizar la revocaci�n para verificar que se revoc� el permiso.
sp_helprotect null, Digitador
/*Propietario de Base de Datos

Cuando un inicio de sesi�n crea una base de datos, autom�ticamente se convierte en propietario de la base de datos 
en caso que no especifique un propietario. Dicho propietario utilizar� el usuario dbo para realizar operaciones de 
las cuales no tendr� restricci�n. Es importante destacar este elemento dado que tambi�n pueden existir propietarios 
asignados desde el rol de base de datos db_owner, por lo tanto una base de datos puede tener m�s de un propietario. 
No se recomienda tener varios propietarios al mismo tiempo dado que pondr�a en riesgo la seguridad de la base de datos.*/

/*Ejercicio 5: Ahora crearemos un login de acceso llamado �Administrador� el cual convertiremos en propietario de 
la Base de Datos Northwind, esto le permitir� acceder la base de datos y administrar permisos a otros usuarios.*/

--1. Creaci�n del inicio de sesi�n Administrador

Create login Administrador with password = 'maestria2018'

--2. Asignaci�n de Propietario de la BD

use Northwind 
go 
Execute sp_changedbowner 'Administrador'
go
--3. Ejecutar procedimiento para verificar el cambio

sp_helpdb Northwind

--4. Resultado de la ejecuci�n del procedimiento

/*Se observa en la ejecuci�n del procedimiento que el owner es la entidad Administrador, lo interesante de 
este caso, es que no necesariamente la cuenta de inicio de sesi�n tuvo que tener un usuario para ser propietario, 
sino que directamente se le asigna el permiso.

Todos aquellos usuarios de base de datos con rol de propietario, propietario creador de la base de datos y aquellos 
inicios de sesi�n cuyo rol de servidor sea sysadmin, tendr�n acceso pleno a todos los objetos de la base de datos 
utilizando como interfaz el usuario dbo. Tener presente que el usuario dbo1 estar� presente en todas las bases de datos.*/

--Herencia de Permisos

/*Ejercicio 6: En este escenario cambiaremos la autorizaci�n de propietario de northwind que tiene �Administrador� y 
se la asignaremos a la cuenta de Windows del sistema con sysadmin. Luego le daremos permisos sobre algunos objetos de 
la base de datos con la opci�n de heredar dichos permisos a otros usuarios.*/

--1. Cambio de propietario de la BD Northwind a la cuenta de Windows.

use Northwind 
go 
Execute sp_changedbowner [DESKTOP-2JGMS0L\Admin]

--2. Creando el usuario de Administrador en la BD Northwind.

use Northwind 
go 
Create user Principal from login Administrador

/*3. Asignaci�n de Permisos de Selecci�n en las tablas Employees y Customers con permisos de 
heredar sus permisos a otros usuarios con el comando with grant option*/

Grant select on Customers to Principal with grant option 
Grant select on Employees to Principal with grant option
go
/*Revoque todos los permisos concedidos al usuario �Digitador�, solo deje el permiso de conexi�n a la 
BD Northwind. Verifique los permisos concedidos ejecutando el procedimiento almacenado*/
sp_helprotect null, Digitador
Revoke select on [dbo].[Category Sales for 1997] to Digitador
Revoke select on Customers to Digitador 
Revoke execute on [dbo].[CustOrderHist] to Digitador
Revoke select on Employees to Digitador
Revoke update on Employees to Digitador
Revoke select on [dbo].[Order Details Extended] to Digitador
Revoke select on Orders to Digitador
go
sp_helprotect null, Digitador

/*4. Ingrese a la herramienta con el Inicio de Sesi�n �Administrador� y conecte la consola con la BD Northwind, 
ahora la cuenta Administrador trabaja en Northwind con la cuenta de usuario llamada Principal.*/

/*5. Desde la cuenta Administrador conceda los permisos heredados al usuario �Digitador� en la BD Northwind*/

use Northwind 
go 
Grant select on Customers to Digitador 
Grant select on Employees to Digitador
go
/*6. Conectarse con la cuenta Sistema en la BD Northwind y verificar que tiene los permisos 
concedidos por la cuenta de �Administrador�.*/

sp_helprotect null, Principal

/*Ejercicio 7: En este escenario concederemos permisos para crear objetos b�sicos como tablas, 
vista y procedimientos en la BD Northwind.*/

--1. Crearemos un nuevo inicio de sesi�n llamado �Creador� con los permisos solicitados.

Create login Creador with password = 'maestria2018' 
go 
use Northwind 
go 
Exec sp_adduser Creador, creador -- 2 
go 
Grant create table to creador 
Grant create view to creador 
Grant create procedure to creador

--2. Conectarse con el inicio de sesi�n �Creador� y conecte la BD Northwind. Dado que el usuario tiene por 
--definici�n un esquema con su nombre, este podr� crear los objetos bajo dicho esquema. El esquema se crea 
--autom�ticamente en la base de datos cuando se crea el usuario.

use Northwind 
go 
Create table creador.Persona(id int) 
go 
Create view creador.vistaClientes 
as 
Select * from Customers 
go 
Create procedure creador.Noclientes 
as 
Select count(*) from customers as Cantidad
go
--3. Verificar en el explorador de objetos que los objetos han sido creados por el usuario.

/*Ejercicio 8: Para esta pr�ctica crearemos un esquema nuevo dentro de la Base de datos 
Northwind y asignaremos al usuario �Creador� como propietario de dicho esquema. Dado que 
tiene permisos de creaci�n de tablas, vistas y procedimientos, podr� realizar objetos bajo 
este esquema.*/

--1. Desde la cuenta de Windows con permisos sysadmin crearemos el esquema con nombre 
--Reporte en la base de datos Northwind.

use Northwind 
go 
Create schema Reporte
go
--2. Ahora asignaremos a la cuenta de usuario Creador como propietario del Esquema Reporte, 
--esto le permitir� utilizar dicho esquema para crear objetos.

USE [Northwind] 
GO 
ALTER AUTHORIZATION ON SCHEMA::[Reporte] TO [creador] 
GO

--3. Desde la cuenta de usuario llamada Creador crearemos una vista utilizando el 
--esquema Reporte.

Create view Reporte.ordenesxcliente 
as 
Select CustomerID, 
count(*) as Cantidad
from orders 
Group by 
CustomerID
go
/*Ejercicio 9: En la consola con una cuenta sysadmin, asignar el rol db_ddladmin a la cuenta 
�creador� para realizar tareas de creaci�n de objetos dentro de la base de datos.*/

--1. Revocaremos todos los permisos que se le han concedido al usuario �creador� en la BD Northwind.

use Northwind 
go 
sp_helprotect null, creador

--2. Otorgar el rol de DB db_ddladmin

use Northwind 
go
sp_addrolemember db_ddladmin, creador

--3. Abrir una consola de trabajo con la cuenta de usuario �creador� en la BD Northwind 
--y comprobar los permisos que han sido asignados con el rol de base de datos.

use northwind 
go

Create table dbo.Prueba(id int)

--4. Comprobar que el usuario no tiene permiso al acceso de registros a la tabla 
--creada por el mismo.

Select * from Prueba

--5. Personalizar los permisos concedidos al usuario creador negando la creaci�n de vistas.

Deny create view to Creador
go
--6. Confirmar que el permiso de creaci�n de vistas ha sido denegado 
--aunque este contemple el Rol de Base de Datos db_ddladmin

Create view creador.datosCliente 
as 
Select * from Customers
go
--7. Revocar la negaci�n al permiso de vistas

Revoke create view to Creador
go
--8. Confirmar la creaci�n de la vista dado que la Denegaci�n ha sido revocada.

Create view creador.datosCliente 
as 
Select * from Customers
go

/*Ejercicio 10: Revocar el rol de base de datos db_ddladmin al usuario �Creador�, conceder 
el rol de base de datos db_datareader que le dar� permisos de lectura en todas las tablas
de la base de datos.*/

--1. Eliminar el rol al usuario �Creador�
use Northwind
go
sp_droprolemember db_ddladmin, creador
go
sp_addrolemember db_datareader, creador
--2. Comprobar que el usuario �Creador� tiene permisos de selecci�n en todas las tablas.

SELECT * FROM Employees
SELECT * FROM Region

--3. Eliminar los permisos de selecci�n en la tabla Employees y Region

Deny Select on Employees to Creador
Deny select on Region to Creador
go
--4. Comprobar que los permisos de selecci�n han sido denegados.

--5. Revisar los permisos y denegaciones asignadas al usuario.

sp_helprotect null, creador
go
sp_helplogins creador


/*Creaci�n de Roles*/

/*Ejercicio 11: Desde una cuenta Sysadmin, crear un rol de base de datos en Northwind 
llamado �Consulta� y asignar los permisos necesarios para visualizar todos los registros 
de las tablas, vistas y procedimientos almacenados.*/

--1. Creaci�n del Rol de Base de datos

Create Role Consulta

--2. Asignaci�n de permisos

Grant select on database:: Northwind to consulta 
Grant Execute on database:: Northwind to consulta

--3. Asignaci�n del Rol �Consulta� al usuario de BD �Creador�

Execute sp_addrolemember Consulta, Creador
go
--4. Confirmar en la consola de �Creador� que tiene los permisos concedidos por el rol.

--5. Revisar los permisos y denegaciones asignadas al usuario.

sp_helplogins creador

--6. Dado que el rol de base de datos �Consulta� tiene todos los permisos de acceso a 
--lectura de todas las tablas, no es necesario que tenga asignado el rol db_datareader.

Use Northwind 
go 
Execute sp_droprolemember Consulta, Creador

/*Roles de Aplicaci�n*/

/*Ejercicio 12: Creaci�n de un Rol de aplicaci�n con permisos �nicamente para modificar 
seleccionar, insertar y modificar la tabla [dbo].[Order Details] dicha tabla contiene 
los detalles de las �rdenes realizadas por los usuarios, una vez ingresada no se puede modificar.*/

--1. Desde una cuenta Sysadmin crearemos el rol de aplicaci�n.

Create application role Actualiza_Detalle_Orden 
with password = 'maestria2018'

--2. Asignaci�n de Permisos al rol de aplicaci�n.

Grant select on [dbo].[Order Details] to Actualiza_Detalle_Orden 
Grant update on [dbo].[Order Details] to Actualiza_Detalle_Orden 
Grant insert on [dbo].[Order Details] to Actualiza_Detalle_Orden

--3. Ingrese a la consola desde la cuenta �Creador� y active el rol

Execute sp_setapprole 
Actualiza_Detalle_orden, 'maestria2018'

--4. Asignar nuevos permisos al rol de aplicaci�n y confirmar que el usuario puede 
--ejecutarlos en tiempo real.

Grant select on [dbo].[Orders] to Actualiza_Detalle_Orden

--5. Confirmar que el usuario al activar el rol de aplicaci�n suspende temporalmente 
--todos los permisos que tiene asignado y obtiene �nicamente los permisos concedidos 
--por el rol de aplicaci�n.

--6. Para cancelar el rol de aplicaci�n

sp_unsetapprole

--7. Otra opci�n es desconectar el usuario del sistema y vuelva a conectar, observar� que 
--sus permisos anteriores han regresado.

/*Administraci�n por Esquemas*/

/*Ejercicio 13: Crear un usuario en la base de datos AdventureWorks2012 al inicio de sesi�n 
llamado �Creador�, asignarle permiso de lectura en el esquema de �Production� y permisos de 
ejecuci�n de procedimientos almacenados en el esquema dbo.*/

--1. Creaci�n del usuario en la Base de Datos AdventureWorks

use AdventureWorks2019 
go 
sp_adduser Creador, visitante

--2. Asignaci�n de permisos en el esquema de producci�n

Grant select on Schema :: Production to Visitante

--3. Asignaci�n de permisos sobre los procedimiento almacenados en el esquema

Grant execute on Schema :: dbo to Visitante
go
--4. Acceder con la cuenta �Creador� a la base de datos AdventureWorks2019 y comprobar 
--los permisos concedidos en base al esquema seleccionado.

sp_helplogins creador

--5. Denegar el permiso de selecci�n en la tabla products

Deny select on production.Product to Visitante

--6. Al igual que la administraci�n por roles, si deseamos denegar un acceso concedido ya 
--sea por rol o esquema, entonces aplicamos el comando Deny

--7. Revocar los permisos concedidos por el esquema y revocar la negaci�n en la tabla product

Revoke select on Schema :: Production to Visitante 
Revoke execute on Schema :: dbo to Visitante

Revoke select on production.Product to Visitante

--8. Revisar en la cuenta �Creador� que el usuario ya no cuenta con los permisos.
sp_helprotect null, Creador