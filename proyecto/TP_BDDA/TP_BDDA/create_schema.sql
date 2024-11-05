USE Com2900G08;
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'creacion')
BEGIN
    EXEC('CREATE SCHEMA creacion');
END
ELSE
	PRINT('Ya existe el esquema "creacion"')
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'insertar')
BEGIN
    EXEC('CREATE SCHEMA insertar');
END
ELSE
	PRINT('Ya existe el esquema "insertar"')
GO