CREATE DATABASE argumentmapper_local;
GO

CREATE LOGIN argumentmapper_local_dbo  WITH PASSWORD = 'Argumentmapper_dbo15';  
GO  

CREATE LOGIN argumentmapper_local_user  WITH PASSWORD = 'Argumentmapper_dbo15';  
GO  

USE argumentmapper_local;
GO

-- Creates a database user for the login created above.  
CREATE USER argumentmapper_local_dbo FOR LOGIN network_local_dbo;
GO

exec sp_addrolemember 'db_owner', 'argumentmapper_local_dbo';
GO

CREATE USER network_local_user FOR LOGIN argumentmapper_local_user;
GO
