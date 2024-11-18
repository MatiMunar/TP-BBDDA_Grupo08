USE Com2900G08;
GO

-- Esta query es para dar rol de 'Supervisor' de manera dinámica a los empleados que tengan ese cargo.

DECLARE @sql NVARCHAR(MAX) = N'';

-- Verificamos si todos los usuarios existen en la base de datos para darle el rol de 'Supervisor'
IF EXISTS (
    SELECT 1
    FROM creacion.empleado e
    WHERE e.cargo = 'Supervisor'
      AND NOT EXISTS (
          SELECT 1
          FROM sys.database_principals p
          WHERE p.name = e.nombre
      )
)
BEGIN
    RAISERROR('Uno o más usuarios no existen en la base de datos.', 16, 1);
END
ELSE
BEGIN
    -- En caso de que existan los usuarios, les damos el rol dinámicamente
    SELECT @sql += N'
        IF NOT EXISTS (
            SELECT 1
            FROM sys.database_role_members rm
            INNER JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
            INNER JOIN sys.database_principals u ON rm.member_principal_id = u.principal_id
            WHERE r.name = ''Supervisor'' AND u.name = ''' + nombre + N'''
        )
        BEGIN
            ALTER ROLE Supervisor ADD MEMBER [' + nombre + N'];
        END;'
    FROM creacion.empleado
    WHERE cargo = 'Supervisor';

    EXEC sp_executesql @sql;
END;
GO
