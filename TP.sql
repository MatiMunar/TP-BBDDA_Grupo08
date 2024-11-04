create database Com2900G08
go

use Com2900G08
go

create schema supermrkt
go



--EXEC sp_enum_oledb_providers; COmando para verificar si teniamos instalado el controlador Microsoft
	EXEC sp_configure 'show advanced options', 1;
	RECONFIGURE;

	EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
	RECONFIGURE;

	EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 1
	GO

	EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'DynamicParameters', 1
	GO

	print('linea 24')
	go

CREATE OR ALTER PROCEDURE supermrkt.importar_Electronic_Accesories
as
begin
	drop table if exists supermrkt.electronicaEXCEL

	SELECT *
	INTO supermrkt.electronicaEXCEL -- Cambia a tu tabla o usa una tabla temporal
	FROM OPENROWSET('Microsoft.ACE.OLEDB.16.0',
		'Excel 12.0;Database=C:\Users\felid\Downloads\TP_integrador_Archivos (1)\TP_integrador_Archivos\Productos\Electronic accessories.xlsx;HDR=YES',
    'SELECT * FROM [Sheet1$]')

	drop table if exists supermrkt.accesorios_electronicos
	create table supermrkt.accesorios_electronicos
	(
	id int primary key identity(1,1),
	nombre_producto char(60),
	precio_Unitario_usd decimal(8,2) 
	)

	insert into supermrkt.accesorios_electronicos (nombre_producto, precio_unitario_usd)
	select
	cast([Product] as char(60)) as nombre_producto,
	cast([Precio Unitario en dolares] as decimal (8,2)) as precio_unitario_usd
	from supermrkt.electronicaEXCEL
	drop table supermrkt.electronicaEXCEL

END

print('linea 54')
go

exec supermrkt.importar_Electronic_Accesories
select * from supermrkt.accesorios_electronicos


	EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'AllowInProcess', 0
	GO

	EXEC sp_MSSet_oledb_prop N'Microsoft.ACE.OLEDB.16.0', N'DynamicParameters', 0
	GO

	EXEC sp_configure 'Ad Hoc Distributed Queries', 0;
	RECONFIGURE;
	go

--Store procedure para insertar datos de catalogo.CSV
create or alter procedure supermrkt.importar_CatalogoCSV
as
begin
	 --Creamos tabla temporal para cargar catalogo
	
	drop table if exists supermrkt.catalogoCSV

	create table supermrkt.catalogoCSV
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
	BULK INSERT supermrkt.catalogoCSV
	FROM 'C:\Users\felid\Downloads\TP_integrador_Archivos (1)\TP_integrador_Archivos\Productos\catalogo.csv'
	WITH 
	(
		FORMAT = 'CSV',
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		CODEPAGE = '1252',
		FIRSTROW = 2
	)

	UPDATE supermrkt.catalogoCSV 
	SET name = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(name, ' ', ' '), 'á', ' '), 'ó', ' '), 'ú', ' '), 'é', ' '), ' ', ' '), ' ', ' '), ' ', ' '), ' ', ' '), ' ', ' '), ' ', ' '), ' -', ' ')

	drop table if exists supermrkt.catalogoCSVImportado

	CREATE TABLE supermrkt.catalogoCSVImportado
	(
    id INT PRIMARY KEY,
    categoria CHAR(80),
    name CHAR(70),
    price DECIMAL(8, 2),
    reference_price DECIMAL(8, 2),
    reference_unit CHAR(5),
    date DATETIME
	)

	INSERT INTO supermrkt.catalogoCSVImportado (id, categoria, name, price, reference_price, reference_unit, date)
    SELECT 
        id,
        CAST(category AS CHAR(80)) AS categoria,
        CAST(name AS CHAR(70)) AS name,
        CAST(price AS DECIMAL(8, 2)) AS price,
        CAST(reference_price AS DECIMAL(8, 2)) AS reference_price,
        CAST(reference_unit AS CHAR(5)) AS reference_unit,
        TRY_CAST(date AS DATETIME) AS date
    FROM 
        supermrkt.catalogoCSV;

	drop table supermrkt.catalogoCSV

	select  * from supermrkt.catalogoCSVImportado

end

exec supermrkt.importar_CatalogoCSV
go

--drop database Com2900G08