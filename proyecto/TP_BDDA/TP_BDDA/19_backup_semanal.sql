DECLARE @RutaBase NVARCHAR(255) = 'D:\backups\tp_BDDA\';
DECLARE @Query NVARCHAR(MAX);

-- Backup Completo Semanal
SET @Query = 'BACKUP DATABASE Com2900G08 ' +
             'TO DISK = ''' + @RutaBase + 'Com2900G08_Full.bak'' ' +
             'WITH INIT, NAME = ''Backup Completo Semanal de Com2900G08'';';

EXEC sp_executesql @Query;
GO
