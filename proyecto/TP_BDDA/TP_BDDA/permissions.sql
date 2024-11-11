USE Com2900G08

IF OBJECT_ID('creacion.nota_credito', 'U') IS NOT NULL
BEGIN
    GRANT INSERT, UPDATE, DELETE ON creacion.nota_credito TO Supervisor;
END;
ELSE
	RAISERROR('No existe la tabla nota_credito', 16, 1);
GO
