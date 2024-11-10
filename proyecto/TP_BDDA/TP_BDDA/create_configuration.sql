USE Com2900G08;
GO

EXEC master.dbo.sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC master.dbo.sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

EXEC master.dbo.sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 1
GO

EXEC master.dbo.sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'DynamicParameters', 1
GO