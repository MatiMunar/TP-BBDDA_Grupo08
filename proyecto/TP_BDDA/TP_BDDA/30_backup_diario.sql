DECLARE @RutaBase NVARCHAR(255) = 'D:\backups\tp_BDDA\';
DECLARE @Query NVARCHAR(MAX);

-- Backup Diferencial Diario
SET @Query = 'BACKUP DATABASE Com2900G08 ' +
             'TO DISK = ''' + @RutaBase + 'Com2900G08_Diff.bak'' ' +
             'WITH DIFFERENTIAL, NAME = ''Backup Diferencial Diario de Com2900G08'';';
EXEC sp_executesql @Query;
GO