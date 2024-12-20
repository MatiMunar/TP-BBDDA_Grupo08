USE Com2900G08;
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'creacion')
BEGIN
    EXEC('CREATE SCHEMA creacion');
END
ELSE
	RAISERROR('Ya existe el esquema "creacion"', 16, 1);
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'insertar')
BEGIN
    EXEC('CREATE SCHEMA insertar');
END
ELSE
	RAISERROR('Ya existe el esquema "insertar"', 16, 1);
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'abm_catalogo_producto')
BEGIN
    EXEC('CREATE SCHEMA abm_catalogo_producto');
END
ELSE
	RAISERROR('Ya existe el esquema "abm_catalogo_producto"', 16, 1);
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'abm_detalle_venta')
BEGIN
    EXEC('CREATE SCHEMA abm_detalle_venta');
END
ELSE
	RAISERROR('Ya existe el esquema "abm_detalle_venta"', 16, 1);
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'abm_empleado')
BEGIN
    EXEC('CREATE SCHEMA abm_empleado');
END
ELSE
	RAISERROR('Ya existe el esquema "abm_empleado"', 16, 1);
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'abm_sucursal')
BEGIN
    EXEC('CREATE SCHEMA abm_sucursal');
END
ELSE
	RAISERROR('Ya existe el esquema "abm_sucursal"', 16, 1);
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'abm_venta')
BEGIN
    EXEC('CREATE SCHEMA abm_venta');
END
ELSE
	RAISERROR('Ya existe el esquema "abm_venta"', 16, 1);
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'abm_producto')
BEGIN
    EXEC('CREATE SCHEMA abm_producto');
END
ELSE
	RAISERROR('Ya existe el esquema "abm_producto"', 16, 1);
GO

IF NOT EXISTS (SELECT name FROM sys.schemas	WHERE name = 'utilitarias')
BEGIN
	EXEC('CREATE SCHEMA utilitarias')
END
ELSE
	RAISERROR('Ya existe el esquema "utilitarias"', 16, 1);
GO