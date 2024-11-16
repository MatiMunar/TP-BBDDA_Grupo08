DECLARE @RutaBase NVARCHAR(255) = 'D:\backups\tp_BDDA\';
DECLARE @Query NVARCHAR(MAX);
DECLARE @RecoveryModel NVARCHAR(50);

-- Verificamos el modelo de recuperación actual
SELECT @RecoveryModel = recovery_model_desc
FROM sys.databases
WHERE name = 'Com2900G08';

-- Si el modelo de recuperación no es FULL, lo cambiamos a FULL
IF @RecoveryModel <> 'FULL'
BEGIN
    PRINT 'El modelo de recuperación no es FULL. Se cambiará a FULL.';
    ALTER DATABASE Com2900G08
    SET RECOVERY FULL;
    -- Realizar un backup completo antes de proceder con el log
    SET @Query = 'BACKUP DATABASE Com2900G08 ' +
                 'TO DISK = ''' + @RutaBase + 'Com2900G08_Full_Initial.bak'' ' +
                 'WITH INIT, NAME = ''Backup Completo Inicial de Com2900G08 para asegurar consistencia'';';
    EXEC sp_executesql @Query;
END
ELSE
BEGIN
    PRINT 'El modelo de recuperación ya es FULL.';
END

-- Realizar el Backup del Log de Transacciones
SET @Query = 'BACKUP LOG Com2900G08 ' +
             'TO DISK = ''' + @RutaBase + 'Com2900G08_Log.bak'' ' +
             'WITH INIT, NAME = ''Backup Log de Transacciones de Com2900G08'';';
EXEC sp_executesql @Query;

