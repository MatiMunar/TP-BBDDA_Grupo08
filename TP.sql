--create database Com2900G08

use Com2900G08

create schema transacciones

create schema supermrkt

create table supermrkt.sucursal
(
  ciudad char(20),
  direccion char(100),
  horario char(20),
  telefono char(9),
  primary key (ciudad, direccion)
 )


 create table supermrkt.empleado
(
  id_Empleado int identity (257020, 1) primary key,
  dni_Empleado int,
  cuil_Empleado int,
  nombre char(50),
  apellido char(50),
  direccion char(100),
  mail_personal char(70),
  mail_empresa char(70),
  cargo char(20),
  turno char(20),
  sucursalEmpleado char(20),
  direccionSucursal char(100),
  foreign key (sucursalEmpleado, direccionSucursal) references supermrkt.sucursal (ciudad, direccion)
)

create table transacciones.metodo_De_Pago
(
	id int primary key,
	descripcion char(25)
)

create table supermrkt.linea_De_Producto
(
	id int primary key,
	descripcion char(25)
)

create table supermrkt.Producto
(
	id int primary key,
	nombre_Producto char(80),
	categoria char(70),
	precio_Producto decimal(8,2)
)

--drop table supermrkt.electronicaCSV
create table supermrkt.electronicaCSV
(
	id int primary key,
	nombre_producto char(200),
	precio_Unitario_usd char(200) 
)

select * from supermrkt.electronicaCSV

--EXEC sp_enum_oledb_providers; COmando para verificar si teniamos instalado el controlador Microsoft

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

SELECT *
INTO supermrkt.electronicaCSV -- Cambia a tu tabla o usa una tabla temporal
FROM OPENROWSET('Microsoft.ACE.OLEDB.16.0',
    'Excel 12.0;Database=C:\Users\Matias\OneDrive\Escritorio\UNLAM\2do Cuatri 2024\Bases de Datos Aplicada\TP_integrador_Archivos\TP_integrador_Archivos\Productos\Electronic accessories.xlsx;HDR=YES',
    'SELECT * FROM [Sheet1$]')

EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1
GO

EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
GO

create table supermrkt.importadosCSV
(
	id int primary key,
	nombre_producto char(40),
	nombre_proveedor char(100),
	categoria char(50),
	cant_X_Unidad char(30),
	precio_Unitario decimal(6, 2)
)

--Store procedure para insertar datos de catalogo.CSV

create or alter procedure supermrkt.importar_CatalogoCSV
as
begin
	 --Creamos tabla temporal para cargar catalogo
	
	drop table if exists supermrkt.##catalogoCSV

	create table supermrkt.##catalogoCSV
	(
		id int primary key,
		category char(200), --poner 255 si falla
		name char(200),
		price char(200),
		reference_price char(200),
		reference_unit char(200),
		date char(200) 
	)

	--Importamos catalogo
	BULK INSERT supermrkt.##catalogoCSV
	FROM 'C:\Users\Matias\OneDrive\Escritorio\UNLAM\2do Cuatri 2024\Bases de Datos Aplicada\TP_integrador_Archivos\TP_integrador_Archivos\Productos\catalogo.csv'
	WITH 
	(
		FORMAT = 'CSV',
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		CODEPAGE = '1252',
		FIRSTROW = 2
	)

	UPDATE supermrkt.##catalogoCSV 
	SET name = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(name, 'Â', 'á'), 'Ã¡', 'á'), 'Ã³', 'ó'), 'Ãº', 'ú'), 'Ã©', 'é'), 'Ã', 'í'), 'í±', 'ñ'), 'í³', 'ó'), 'í', 'í'), 'í©', 'é'), 'í³', 'ó'), 'í-', 'í')

	drop table if exists supermrkt.catalogoCSV

	CREATE TABLE supermrkt.catalogoCSV
	(
    id INT PRIMARY KEY,
    categoria CHAR(80),
    name CHAR(70),
    price DECIMAL(8, 2),
    reference_price DECIMAL(8, 2),
    reference_unit CHAR(5),
    date DATETIME
	)

	INSERT INTO supermrkt.catalogoCSV (id, categoria, name, price, reference_price, reference_unit, date)
    SELECT 
        id,
        CAST(category AS CHAR(80)) AS categoria,
        CAST(name AS CHAR(70)) AS name,
        CAST(price AS DECIMAL(8, 2)) AS price,
        CAST(reference_price AS DECIMAL(8, 2)) AS reference_price,
        CAST(reference_unit AS CHAR(5)) AS reference_unit,
        TRY_CAST(date AS DATETIME) AS date
    FROM 
        supermrkt.##catalogoCSV;

	drop table supermrkt.##catalogoCSV

	select  * from supermrkt.catalogoCSV

end

drop table supermrkt.##catalogoCSV
drop table supermrkt.catalogoCSV

exec supermrkt.importar_CatalogoCSV


SELECT *
FROM supermrkt.catalogoCSV
WHERE name COLLATE Latin1_General_BIN LIKE '%[^A-Za-z0-9 ]%'
                                                                                                                                                                                               
--Tablas a crear:
--venta
--detalle de venta


