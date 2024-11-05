create database Com2900G08
go


use Com2900G08
go

create schema creacion
go
-- Tabla sucursal
CREATE TABLE Com2900G08.creacion.sucursal (
    id_sucursal INT PRIMARY KEY IDENTITY(1,1),
    nombre CHAR(100) NOT NULL,
    ciudad CHAR(100) NOT NULL
);

-- Tabla empleado
CREATE TABLE Com2900G08.creacion.empleado (
    id_empleado INT PRIMARY KEY IDENTITY(1,1),
    nombre CHAR(100) NOT NULL,
    legajo CHAR(50) NOT NULL UNIQUE,
    id_sucursal INT,
    FOREIGN KEY (id_sucursal) REFERENCES Com2900G08.creacion.sucursal(id_sucursal)
);

CREATE TABLE Com2900G08.creacion.producto (
    id_producto INT PRIMARY KEY IDENTITY(1,1),
    nombre_producto VARCHAR(150) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    categoria VARCHAR(100) NOT NULL
);

CREATE TABLE Com2900G08.creacion.catalogo_producto (
    id_catalogo_producto INT PRIMARY KEY IDENTITY(1,1),
    id_producto INT,
    tipo_catalogo VARCHAR(50)
    FOREIGN KEY (id_producto) REFERENCES Com2900G08.creacion.producto(id_producto)
);

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

CREATE TABLE Com2900G08.creacion.detalle_venta (
    id_detalle_venta INT PRIMARY KEY IDENTITY(1,1),
    id_venta INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES Com2900G08.creacion.venta(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Com2900G08.creacion.producto(id_producto)
);