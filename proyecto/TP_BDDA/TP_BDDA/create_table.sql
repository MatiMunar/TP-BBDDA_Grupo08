USE Com2900G08;
GO

-- Tabla sucursal
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'sucursal' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.sucursal (
        id_sucursal INT PRIMARY KEY IDENTITY(1,1),
        ciudad VARCHAR(100) NOT NULL,
		direccion VARCHAR(100) NOT NULL,
		horario varchar(50) NOT NULL,
		telefono VARCHAR(9) NOT NULL,
		CONSTRAINT chk_telefono_formato CHECK (telefono LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]' OR telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
    );
END
ELSE
	PRINT('Ya existe la tabla "sucursal"')
GO

-- Tabla empleado
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'empleado' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.empleado (
        id_empleado INT PRIMARY KEY IDENTITY(1,1),
		legajo INT NOT NULL UNIQUE,
        nombre VARCHAR(100) NOT NULL,
        dni INT NOT NULL UNIQUE,
		direccion VARCHAR(150) NOT NULL,
		email_personal VARCHAR(100) NOT NULL,
		email_empresa VARCHAR(100) NOT NULL,
		cargo VARCHAR(50) NOT NULL,
		sucursal VARCHAR(100) NOT NULL,
		turno VARCHAR(50) NOT NULL,
        id_sucursal INT,
        FOREIGN KEY (id_sucursal) REFERENCES Com2900G08.creacion.sucursal(id_sucursal)
    );
END
ELSE
	PRINT('Ya existe la tabla "empleado"')
GO


-- Tabla catalogo_producto
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'catalogo_producto' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.catalogo_producto (
        id_catalogo_producto INT PRIMARY KEY IDENTITY(1,1),
        tipo_catalogo VARCHAR(50),
    );
END
ELSE
	PRINT('Ya existe la tabla "catalogo_producto"')
GO

-- Tabla producto
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'producto' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.producto (
        id_producto INT PRIMARY KEY IDENTITY(1,1),
        nombre_producto VARCHAR(150) NOT NULL,
        precio DECIMAL(10, 2) NOT NULL,
        categoria VARCHAR(100) NOT NULL
    );
END
ELSE
	PRINT('Ya existe la tabla "producto"')
GO

-- Tabla venta
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'venta' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.venta (
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
    CREATE TABLE creacion.detalle_venta (
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