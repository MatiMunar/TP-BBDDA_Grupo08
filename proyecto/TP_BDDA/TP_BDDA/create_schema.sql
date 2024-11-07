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

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'abm_detalle_venta')
BEGIN
    EXEC('CREATE SCHEMA abm_detalle_venta');
END
ELSE
	PRINT('Ya existe el esquema "abm_detalle_venta"')
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'abm_empleado')
BEGIN
    EXEC('CREATE SCHEMA abm_empleado');
END
ELSE
	PRINT('Ya existe el esquema "abm_empleado"')
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'abm_sucursal')
BEGIN
    EXEC('CREATE SCHEMA abm_sucursal');
END
ELSE
	PRINT('Ya existe el esquema "abm_sucursal"')
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'abm_venta')
BEGIN
    EXEC('CREATE SCHEMA abm_venta');
END
ELSE
	PRINT('Ya existe el esquema "abm_venta"')
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = 'abm_producto')
BEGIN
    EXEC('CREATE SCHEMA abm_producto');
END
ELSE
	PRINT('Ya existe el esquema "abm_producto"')
GO