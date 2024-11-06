USE Com2900G08;
GO

-- Tabla sucursal
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'sucursal' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE Com2900G08.creacion.sucursal (
        id_sucursal INT PRIMARY KEY IDENTITY(1,1),
        nombre VARCHAR(100) NOT NULL,
        ciudad VARCHAR(100) NOT NULL
    );
END
ELSE
	PRINT('Ya existe la tabla "sucursal"')
GO

-- Tabla empleado
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'empleado' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE Com2900G08.creacion.empleado (
        id_empleado INT PRIMARY KEY IDENTITY(1,1),
        nombre VARCHAR(100) NOT NULL,
        legajo NVARCHAR(50) NOT NULL UNIQUE,
        id_sucursal INT,
        FOREIGN KEY (id_sucursal) REFERENCES Com2900G08.creacion.sucursal(id_sucursal)
    );
END
ELSE
	PRINT('Ya existe la tabla "empleado"')
GO

-- Tabla producto
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'producto' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE Com2900G08.creacion.producto (
        id_producto INT PRIMARY KEY IDENTITY(1,1),
        nombre_producto VARCHAR(150) NOT NULL,
        precio DECIMAL(10, 2) NOT NULL,
        categoria VARCHAR(100) NOT NULL
    );
END
ELSE
	PRINT('Ya existe la tabla "producto"')
GO

-- Tabla catalogo_producto
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'catalogo_producto' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE Com2900G08.creacion.catalogo_producto (
        id_catalogo_producto INT PRIMARY KEY IDENTITY(1,1),
        id_producto INT,
        tipo_catalogo VARCHAR(50),
        FOREIGN KEY (id_producto) REFERENCES Com2900G08.creacion.producto(id_producto)
    );
END
ELSE
	PRINT('Ya existe la tabla "catalogo_producto"')
GO

-- Tabla venta
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'venta' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE Com2900G08.creacion.venta (
        id_venta INT PRIMARY KEY IDENTITY(1,1),
        tipo_factura VARCHAR(50),
        fecha DATE NOT NULL,
        hora TIME NOT NULL,
        medio_pago VARCHAR(50) NOT NULL,
        id_factura CHAR(30),
        id_empleado INT,
        id_sucursal INT,
        FOREIGN KEY (id_empleado) REFERENCES Com2900G08.creacion.empleado(id_empleado),
        FOREIGN KEY (id_sucursal) REFERENCES Com2900G08.creacion.sucursal(id_sucursal)
    );
END
ELSE
	PRINT('Ya existe la tabla "venta"')
GO

-- Tabla detalle_venta
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'detalle_venta' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE Com2900G08.creacion.detalle_venta (
        id_detalle_venta INT PRIMARY KEY IDENTITY(1,1),
        id_venta INT,
        id_producto INT,
        cantidad INT NOT NULL,
        precio_unitario DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (id_venta) REFERENCES Com2900G08.creacion.venta(id_venta),
        FOREIGN KEY (id_producto) REFERENCES Com2900G08.creacion.producto(id_producto)
    );
END
ELSE
	PRINT('Ya existe la tabla "detalle_venta"')
GO