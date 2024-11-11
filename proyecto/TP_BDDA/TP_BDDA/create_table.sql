USE Com2900G08;
GO

-- Tabla sucursal
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'sucursal' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.sucursal (
        id_sucursal INT PRIMARY KEY IDENTITY(1,1),
        ciudad CHAR(100) NOT NULL,
		sucursal CHAR(100) NOT NULL,
		direccion CHAR(100) NOT NULL,
		horario CHAR(50) NOT NULL,
		telefono CHAR(9) NOT NULL,
		CONSTRAINT chk_telefono_formato CHECK (telefono LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]' OR telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
    );
END
ELSE
	RAISERROR('Ya existe la tabla "sucursal"', 16, 1);
GO

-- Tabla empleado
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'empleado' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.empleado (
        id_empleado INT PRIMARY KEY IDENTITY(1,1),
		legajo INT NOT NULL UNIQUE,
        nombre CHAR(100) NOT NULL,
        dni VARBINARY(128) NOT NULL,
		direccion VARBINARY(256) NOT NULL,
        email_personal VARBINARY(256) NOT NULL,
        email_empresa VARBINARY(256) NOT NULL,
		cargo CHAR(50) NOT NULL,
		turno CHAR(50) NOT NULL,
        id_sucursal INT,
        FOREIGN KEY (id_sucursal) REFERENCES Com2900G08.creacion.sucursal(id_sucursal)
    );
END
ELSE
	RAISERROR('Ya existe la tabla "empleado"', 16, 1);
GO


-- Tabla catalogo_producto
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'catalogo_producto' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.catalogo_producto (
        id_catalogo_producto INT PRIMARY KEY IDENTITY(1,1),
        tipo_catalogo CHAR(50),
    );
END
ELSE
	RAISERROR('Ya existe la tabla "catalogo_producto"', 16, 1);
GO

-- Tabla producto
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'producto' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.producto (
        id_producto INT PRIMARY KEY IDENTITY(1,1),
        nombre_producto NCHAR(150) NOT NULL,
        precio DECIMAL(10, 2) NOT NULL,
        categoria NCHAR(150) NOT NULL,
		id_catalogo INT,
		FOREIGN KEY (id_catalogo) REFERENCES Com2900G08.creacion.catalogo_producto(id_catalogo_producto)
    );
END
ELSE
	RAISERROR('Ya existe la tabla "producto"', 16, 1);
GO

-- Tabla venta
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'venta' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.venta (
        id_venta INT PRIMARY KEY IDENTITY(1,1),
        tipo_factura CHAR(50),
        fecha DATE NOT NULL,
        hora TIME NOT NULL,
        medio_pago CHAR(50) NOT NULL,
		tipo_cliente CHAR(50),
		genero CHAR(50),
        id_factura CHAR(30),
        id_empleado INT,
        id_sucursal INT,
        FOREIGN KEY (id_empleado) REFERENCES Com2900G08.creacion.empleado(id_empleado),
        FOREIGN KEY (id_sucursal) REFERENCES Com2900G08.creacion.sucursal(id_sucursal)
    );
END
ELSE
	RAISERROR('Ya existe la tabla "venta"', 16, 1);
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
	RAISERROR('Ya existe la tabla "detalle_venta"', 16, 1);
GO
-- Creación de la tabla nota_credito
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'nota_credito' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.nota_credito (
        id_nota_credito INT PRIMARY KEY IDENTITY(1,1),
        id_venta INT NOT NULL,
        valor DECIMAL(10, 2) NOT NULL,
        fecha_emision DATE NOT NULL DEFAULT GETDATE(), -- Fecha de emisión de la nota
        tipo CHAR(50) CHECK (tipo IN ('Reembolso', 'Cambio')),
        FOREIGN KEY (id_venta) REFERENCES creacion.venta(id_venta)
    );
END
ELSE
    RAISERROR('La tabla "nota_credito" ya existe.', 16, 1);
GO