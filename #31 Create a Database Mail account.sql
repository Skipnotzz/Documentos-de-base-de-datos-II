-- Create a Database Mail account  

EXECUTE msdb.dbo.sysmail_add_account_sp  
    @account_name = 'ABD2021',  
    @description = 'Mail account for use by all database users.',  
    @email_address = 'empresaelec1995@gmail.com',  
    @replyto_address = 'empresaelec1995@gmail.com ',  
    @display_name = 'Automated Mailer',  
    @mailserver_name = 'smtp.gmail.com',
    @port=587,
    @enable_ssl=1,
    @username= 'empresaelec1995@gmail.com ',
    @password='mameluco3000@';

-- Create a Database Mail profile  

EXECUTE msdb.dbo.sysmail_add_profile_sp  
    @profile_name = 'ABD2021 Public Profile',  
    @description = 'Profile used for jobs mail.';  

-- Add the account to the profile  
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp  
    @profile_name = 'ABD2021 Public Profile',  
    @account_name = 'ABD2021',  
    @sequence_number =1 ;

-- Grant access to the profile to all users in the msdb database  
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp  
    @profile_name = 'ABD2021 Public Profile',  
    @principal_name = 'public',  
    @is_default = 1;

/*Eliminar cuenta y perfil*/

-- Desligar la cuenta del perfil
EXECUTE [msdb].DBO.[sysmail_delete_profileaccount_sp]
@profile_name = 'ABD2021 Public Profile',
@account_name = 'ABD2021';

-- Eliminar cuenta
execute msdb.[dbo].[sysmail_delete_account_sp]
@account_name = 'ABD2021';

-- Eliminar profile
EXECUTE msdb.[dbo].[sysmail_delete_profile_sp]
@profile_name = 'ABD2021 Public Profile'

/*Activar la parte del correo*/
GO
sp_configure 'show advanced options',1;
RECONFIGURE
GO
sp_configure 'Database Mail Xps',1;
RECONFIGURE
GO

/*Enviar correo*/

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'ABD2021 Public Profile',  
    @recipients = 'empresaelec1995@gmail.com ',  
    @body = 'Esta es una prueba de envío de correo.',  
    @subject = 'Automated Success Message';

/*Enviar correo*/

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'ABD2021 Public Profile',  
    @recipients = ' empresaelec1995@gmail.com',    
    @query = 'SELECT COUNT(*) FROM AdventureWorks2019.Production.WorkOrder WHERE DueDate > 2004-04-30
	AND  DATEDIFF(dd, 2004-04-30, DueDate) > 2' ,  
    @subject = 'Work Order Count',  
    @attach_query_result_as_file = 1;

--sp_add_operator

USE msdb;  
GO 

EXEC dbo.sp_add_operator  
    @name = 'TransferenciaBeneficios',  
    @enabled = 1,  
    @email_address = 'empresaelec1995@gmail.com ',   
    @weekday_pager_start_time = 080000,  
    @weekday_pager_end_time = 230000,  
    @pager_days = 62;  
GO

--sp_add_alert

USE [msdb]
GO
EXEC msdb.dbo.sp_add_alert @name=N'Prueba', --Nombre de la alerta
             @message_id=0, --Mensaje de error queda deshabilitado
             @severity=14, --Severidad 014
             @enabled=1, --Alerta habilitada
             @delay_between_responses=0, --No tendra un retraso al enciar la alerta
             @include_event_description_in=1,  --Incluir mensaje del error en el correo
             @notification_message=N'Esta es una alerta de prueba' --Mensaje personalizado
GO

--sp_add_notification

EXEC msdb.dbo.sp_add_notification 
	@alert_name=N'Prueba', 	
	@operator_name=N'TransferenciaBeneficios', 	
	@notification_method = 1
--Agregamos esa alerta al operador TransferenciaBeneficios
GO