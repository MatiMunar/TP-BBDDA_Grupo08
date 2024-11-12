USE Com2900G08;
GO

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'ALTER ROLE Supervisor ADD MEMBER [' + nombre + N']; '
FROM creacion.empleado
WHERE cargo = 'Supervisor';

EXEC sp_executesql @sql;
GO
