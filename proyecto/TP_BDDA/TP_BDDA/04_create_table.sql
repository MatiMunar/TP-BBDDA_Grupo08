USE Com2900G08;
GO

-- Tabla sucursal
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'sucursal' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.sucursal (
        id_sucursal INT IDENTITY(1,1) PRIMARY KEY,
        ciudad CHAR(50) NOT NULL,
        sucursal CHAR(50) NOT NULL,
        direccion CHAR(100) NOT NULL,
        horario CHAR(50) NOT NULL,
        telefono CHAR(9) NOT NULL
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
        id_catalogo_producto INT IDENTITY(1,1) PRIMARY KEY,
        tipo_catalogo CHAR(50) NOT NULL
    );
END
ELSE
    RAISERROR('Ya existe la tabla "catalogo_producto"', 16, 1);
GO

-- Tabla producto
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'producto' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.producto (
        id_producto INT IDENTITY(1,1) PRIMARY KEY,
        id_catalogo INT,
        nombre_producto NCHAR(150),
        precio DECIMAL(10, 2) NOT NULL,
        categoria CHAR(150) NOT NULL,
		tipo CHAR(10) CHECK (tipo IN ('Nacional', 'Importado')),
        FOREIGN KEY (id_catalogo) REFERENCES creacion.catalogo_producto(id_catalogo_producto)
    );
END
ELSE
    RAISERROR('Ya existe la tabla "producto"', 16, 1);
GO

-- Tabla venta
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'venta' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.venta (
        id_venta INT IDENTITY(1,1) PRIMARY KEY,
        id_sucursal INT,
        id_empleado INT,
        fecha DATE NOT NULL,
        hora TIME NOT NULL,
        monto_total DECIMAL(10, 2),
		estado_venta CHAR(20) DEFAULT 'Pagada',
        FOREIGN KEY (id_empleado) REFERENCES creacion.empleado(id_empleado),
        FOREIGN KEY (id_sucursal) REFERENCES creacion.sucursal(id_sucursal)
    );
END
ELSE
    RAISERROR('Ya existe la tabla "venta"', 16, 1);
GO

-- Tabla detalle_venta
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'detalle_venta' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.detalle_venta (
        id_detalle_venta INT IDENTITY(1,1) PRIMARY KEY,
        id_venta INT,
        id_producto INT NOT NULL,
        cantidad INT NOT NULL,
        precio_unitario DECIMAL(10, 2) NOT NULL,
        subtotal DECIMAL(10, 2) NOT NULL,
		numero_factura CHAR(30) NOT NULL
        FOREIGN KEY (id_venta) REFERENCES creacion.venta(id_venta),
        FOREIGN KEY (id_producto) REFERENCES creacion.producto(id_producto)
    );
END
ELSE
    RAISERROR('Ya existe la tabla "detalle_venta"', 16, 1);
GO

-- Crear la tabla supermercado
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'supermercado' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.supermercado (
        CUIT CHAR(15),
        nombre_supermercado CHAR(30),
        CONSTRAINT PK_Supermercado PRIMARY KEY (cuit, nombre_supermercado)
    );
END
ELSE
    RAISERROR('Ya existe la tabla "supermercado"', 16, 1);
GO

-- Tabla factura
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'factura' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.factura (
        id_factura INT IDENTITY(1,1) PRIMARY KEY,
        tipo_factura CHAR(5),
		numero_factura CHAR(30) NOT NULL,
        IVA DECIMAL(3,2) DEFAULT 1.21,
        fecha_emision DATE DEFAULT GETDATE(),
        subtotal_sin_IVA DECIMAL(10,2),
        monto_total_con_IVA DECIMAL(10,2),
        CUIT CHAR(15),
        nombre_supermercado CHAR(30),
        FOREIGN KEY (CUIT, nombre_supermercado) REFERENCES creacion.supermercado(CUIT, nombre_supermercado)
    );
END
ELSE
    RAISERROR('Ya existe la tabla "factura"', 16, 1);
GO

-- Tabla nota_credito
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'nota_credito' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.nota_credito (
        id_nota_credito INT IDENTITY(1,1) PRIMARY KEY,
        id_factura INT NOT NULL,
        valor DECIMAL(10, 2) NOT NULL,
        fecha_emision DATE NOT NULL DEFAULT GETDATE(),
        FOREIGN KEY (id_factura) REFERENCES creacion.factura(id_factura)
    );
END
ELSE
    RAISERROR('Ya existe la tabla "nota_credito"', 16, 1);
GO

-- Tabla medio_de_pago
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'medio_de_pago' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.medio_de_pago (
        id_medio_pago INT IDENTITY(1,1) PRIMARY KEY,
        tipo_medio_pago CHAR(50) CHECK (tipo_medio_pago IN ('Credit card', 'Tarjeta de credito', 'Cash', 'Efectivo', 'Ewallet', 'Billetera electronica'))
    );
END
ELSE
    RAISERROR('Ya existe la tabla "medio_de_pago"', 16, 1);
GO

-- Tabla pago
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'pago' AND schema_id = SCHEMA_ID('creacion'))
BEGIN
    CREATE TABLE creacion.pago (
        id_pago INT IDENTITY(1,1) PRIMARY KEY,
        id_factura INT,
        monto DECIMAL(10,2),
        fecha_pago DATE,
        hora_pago TIME,
		id_medio_pago INT,
        FOREIGN KEY (id_factura) REFERENCES creacion.factura(id_factura),
		FOREIGN KEY (id_medio_pago) REFERENCES creacion.medio_de_pago(id_medio_pago)
    );
END
ELSE
    RAISERROR('Ya existe la tabla "pago"', 16, 1);
GO