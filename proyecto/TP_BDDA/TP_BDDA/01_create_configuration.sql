USE Com2900G08;
GO

EXEC dbo.sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC dbo.sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

EXEC dbo.sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 1
GO

EXEC dbo.sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'DynamicParameters', 1
GO

EXEC dbo.sp_configure 'xp_cmdshell', 1; -- Para la API
RECONFIGURE;
GO

EXEC dbo.sp_configure 'Ole Automation Procedures', 1;
RECONFIGURE;
GO

EXEC dbo.sp_configure 'Agent XPs', 1; -- Para automatizar los backups
RECONFIGURE;
GO