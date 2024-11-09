use Com2900G08
GO

DROP PROCEDURE IF EXISTS insertar.datos_catalogo;
GO
CREATE PROCEDURE insertar.datos_catalogo
	@rutaArchivo NVARCHAR(255)
AS
BEGIN
    -- Creamos la tabla temporal
    CREATE TABLE #temp_catalogo (
        id INT,
        category NVARCHAR(100),
        name NVARCHAR(150),
        price NVARCHAR(50),           -- Usamos NVARCHAR para aceptar cualquier formato sin error
        reference_price NVARCHAR(50), 
        reference_unit NVARCHAR(50),
        date DATETIME
    );
    
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'
    BULK INSERT #temp_catalogo
    FROM ''' + @rutaArchivo + '''
    WITH (
        CHECK_CONSTRAINTS,
        FORMAT = ''CSV'',
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''0x0a'',
        FIRSTROW = 2,
        CODEPAGE = ''65001''
    )';

	EXEC sp_executesql @sql;

    -- Insertar los datos en la tabla producto con conversión condicional
    INSERT INTO creacion.producto (nombre_producto, precio, categoria)
    SELECT 
        name,
        TRY_CAST(price AS DECIMAL(8,2)) AS price, -- Convierte a DECIMAL, o NULL si no es posible
        category
    FROM #temp_catalogo t
    WHERE NOT EXISTS (
        SELECT 1
        FROM creacion.producto p
        WHERE p.nombre_producto = t.name
          AND p.categoria = t.category
    );

    -- Limpiar la tabla temporal
    DROP TABLE #temp_catalogo;

    PRINT 'Datos insertados correctamente en la tabla producto.';
END;
GO

DROP PROCEDURE IF EXISTS insertar.datos_electronic_accessories;
GO
CREATE PROCEDURE insertar.datos_electronic_accessories
	 @rutaArchivo NVARCHAR(255)
AS
BEGIN
    -- Creamos la tabla temporal
    CREATE TABLE #temp_electronic_accessories (
        Product NVARCHAR(150),
        [Precio Unitario en dolares] NVARCHAR(50)   -- NVARCHAR para manejar cualquier formato sin error
    );

    -- Cargar datos desde el archivo Excel a la tabla temporal
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'
    INSERT INTO #temp_electronic_accessories (Product, [Precio Unitario en dolares])
    SELECT Product, [Precio Unitario en dolares]
    FROM OPENROWSET(
        ''Microsoft.ACE.OLEDB.16.0'', 
        ''Excel 12.0;HDR=YES;Database=' + @rutaArchivo + ''', 
        ''SELECT * FROM [Sheet1$]''
    )';

	EXEC sp_executesql @sql;

    INSERT INTO creacion.producto (nombre_producto, precio, categoria)
    SELECT 
        Product,
        TRY_CAST(REPLACE([Precio Unitario en dolares], ',', '.') AS DECIMAL(8,2)) AS Price,  -- Convierte a DECIMAL, cambiando la coma por punto
        'Electronic accessories'
    FROM #temp_electronic_accessories t
    WHERE NOT EXISTS (
        SELECT 1
        FROM creacion.producto p
        WHERE p.nombre_producto = t.Product
          AND p.categoria = 'Electronic accessories'
    );

    DROP TABLE #temp_electronic_accessories;

    PRINT 'Datos insertados correctamente en la tabla producto.';
END;
GO

DROP PROCEDURE IF EXISTS insertar.datos_productos_importados;
GO
CREATE PROCEDURE insertar.datos_productos_importados
	@rutaArchivo NVARCHAR(255)
AS
BEGIN
    -- Crear la tabla temporal para almacenar los datos del archivo Excel
    CREATE TABLE #temp_productos_importados (
        IdProducto NVARCHAR(50),
        NombreProducto NVARCHAR(150),
        Proveedor NVARCHAR(150),
        Categoría NVARCHAR(100),
        CantidadPorUnidad NVARCHAR(100),
        PrecioUnidad NVARCHAR(50)   -- NVARCHAR para manejar cualquier formato
    );

    -- Cargar los datos desde el archivo Excel a la tabla temporal
     DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'
    INSERT INTO #temp_productos_importados (IdProducto, NombreProducto, Proveedor, Categoría, CantidadPorUnidad, PrecioUnidad)
    SELECT IdProducto, NombreProducto, Proveedor, Categoría, CantidadPorUnidad, PrecioUnidad
    FROM OPENROWSET(
        ''Microsoft.ACE.OLEDB.16.0'', 
        ''Excel 12.0;HDR=YES;Database=' + @rutaArchivo + ''', 
        ''SELECT * FROM [Listado de Productos$]''
    )';

	EXEC sp_executesql @sql;

    INSERT INTO creacion.producto (nombre_producto, precio, categoria)
    SELECT 
        NombreProducto,
        TRY_CAST(REPLACE(PrecioUnidad, ',', '.') AS DECIMAL(10,2)) AS Precio,  -- Convierte a DECIMAL reemplazando coma por punto
        Categoría
    FROM #temp_productos_importados t
    WHERE NOT EXISTS (
        SELECT 1
        FROM creacion.producto p
        WHERE p.nombre_producto = t.NombreProducto
          AND p.categoria = t.Categoría
    );

    DROP TABLE #temp_productos_importados;

    PRINT 'Datos insertados correctamente en la tabla producto.';
END;
GO

DROP PROCEDURE IF EXISTS insertar.informacion_complementaria;
GO
CREATE PROCEDURE insertar.informacion_complementaria
	@rutaArchivo NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Crear tabla temporal para sucursales
        CREATE TABLE #temp_sucursal (
            Ciudad NVARCHAR(100),
            ReemplazarPor NVARCHAR(100),
            Direccion NVARCHAR(250),
            Horario NVARCHAR(100),
            Telefono NVARCHAR(20)
        );

        -- Cargar datos desde la hoja 'sucursal'
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'
        INSERT INTO #temp_sucursal (Ciudad, ReemplazarPor, Direccion, Horario, Telefono)
        SELECT Ciudad, [Reemplazar Por], Direccion, Horario, Telefono
        FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.16.0'',
            ''Excel 12.0;HDR=YES;Database=' + @rutaArchivo + ''',
            ''SELECT * FROM [sucursal$]''
        )';
        EXEC sp_executesql @sql;

        -- Insertar datos en la tabla sucursal evitando duplicados
        INSERT INTO creacion.sucursal (ciudad, direccion, horario, telefono)
        SELECT 
            ReemplazarPor, 
            direccion,
			horario,
			telefono
        FROM #temp_sucursal ts
        WHERE NOT EXISTS (
            SELECT 1
            FROM creacion.sucursal s
            WHERE s.ciudad = ts.ReemplazarPor AND s.ciudad = ts.Ciudad
        );

        -- Crear tabla temporal para empleados
        CREATE TABLE #temp_empleado (
            LegajoID INT,
            Nombre VARCHAR(100),
            Apellido VARCHAR(100),
            DNI INT,
            Direccion NVARCHAR(150),
            EmailPersonal NVARCHAR(100),
            EmailEmpresa NVARCHAR(100),
            CUIL VARCHAR(50),
            Cargo NVARCHAR(50),
            Sucursal NVARCHAR(100),
            Turno NVARCHAR(50)
        );

        -- Cargar datos desde la hoja 'Empleados'
        SET @sql = N'
        INSERT INTO #temp_empleado (LegajoID, Nombre, Apellido, DNI, Direccion, EmailPersonal, EmailEmpresa, CUIL, Cargo, Sucursal, Turno)
        SELECT [Legajo/ID], [Nombre], [Apellido], [DNI], [Direccion], [Email Personal], [Email Empresa], [CUIL], [Cargo], [Sucursal], [Turno]
        FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.16.0'',
            ''Excel 12.0;HDR=YES;Database=' + @rutaArchivo + ''',
            ''SELECT * FROM [Empleados$]''
        )';
        EXEC sp_executesql @sql;

		INSERT INTO creacion.empleado (legajo, nombre, dni, direccion, email_personal, email_empresa, cargo, sucursal, turno, id_sucursal)
		SELECT
			e.legajoID,
			CONCAT(e.Nombre, ' ', e.Apellido),
			e.DNI,
			e.Direccion,
			REPLACE(REPLACE(e.EmailPersonal,' ', ''),CHAR(9),'') AS EmailPersonal,
			REPLACE(REPLACE(e.EmailEmpresa,' ', ''),CHAR(9),'') AS EmailEmpresa, 
			e.Cargo,
			e.Sucursal,
			e.Turno,
			s.id_sucursal  
		FROM #temp_empleado e
		INNER JOIN creacion.sucursal s ON e.Sucursal = s.ciudad
		WHERE NOT EXISTS (
			SELECT 1
			FROM creacion.empleado emp
			WHERE emp.legajo = e.LegajoID
		)
		AND TRY_CAST(e.LegajoID AS int) IS NOT NULL
		AND TRY_CAST(e.DNI AS int) IS NOT NULL


        -- Crear tabla temporal para clasificacion de productos
        CREATE TABLE #temp_clasificacion_producto (
            LineaDeProducto NVARCHAR(100),
            Producto NVARCHAR(100)
        );

        SET @sql = N'
        INSERT INTO #temp_clasificacion_producto (LineaDeProducto, Producto)
        SELECT [Línea de producto], Producto
        FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.16.0'',
            ''Excel 12.0;HDR=YES;Database=' + @rutaArchivo + ''',
            ''SELECT * FROM [Clasificacion productos$]''
        )';
        EXEC sp_executesql @sql;

        -- Insertar datos en la tabla catalogo_producto evitando duplicados
        INSERT INTO creacion.catalogo_producto (tipo_catalogo)
        SELECT 
            DISTINCT(cp.LineaDeProducto)  
        FROM #temp_clasificacion_producto cp
     

        DROP TABLE #temp_sucursal;
        DROP TABLE #temp_empleado;
        DROP TABLE #temp_clasificacion_producto;

        COMMIT TRANSACTION;  -- Confirmar la transacción
        PRINT 'Datos cargados correctamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;  -- Revertir la transacción en caso de error
        PRINT 'Error al cargar los datos: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

DROP PROCEDURE IF EXISTS insertar.ventas_registradas;
GO
CREATE PROCEDURE insertar.ventas_registradas
	@rutaArchivo NVARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Crear tabla temporal para ventas
        CREATE TABLE #temp_ventas (
            ID_Factura NVARCHAR(50),
            Tipo_de_Factura NVARCHAR(1),
            Ciudad NVARCHAR(100),
            Tipo_de_Cliente NVARCHAR(20),
            Genero NVARCHAR(10),
            Producto NVARCHAR(150),
            Precio_Unitario DECIMAL(10, 2),
            Cantidad INT,
            Fecha DATE,
            Hora TIME,
            Medio_de_Pago NVARCHAR(50),
            Empleado NVARCHAR(100),
            Identificador_de_Pago NVARCHAR(50)
        );

        -- Cargar datos desde el archivo CSV
        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'
        BULK INSERT #temp_ventas
        FROM ''' + @rutaArchivo + '''
        WITH (
            CHECK_CONSTRAINTS,
            FORMAT = ''CSV'',
            FIELDTERMINATOR = '';'',      
            ROWTERMINATOR = ''0x0D0A'',     
            FIRSTROW = 2,                -- Saltar la fila de encabezado
            CODEPAGE = ''65001''
        )';
        EXEC sp_executesql @sql;

        -- Insertar datos en la tabla venta evitando duplicados
        INSERT INTO creacion.venta (id_factura, tipo_factura, fecha, hora, medio_pago, id_empleado, id_sucursal)
        SELECT 
            ID_Factura,
            Tipo_de_Factura,
            CAST(Fecha AS DATE),
            CAST(Hora AS TIME),
            Medio_de_Pago,
            (SELECT TOP 1 id_empleado FROM creacion.empleado WHERE legajo = Empleado),  -- Relacionar con el empleado
            (SELECT TOP 1 id_sucursal FROM creacion.sucursal WHERE ciudad = Ciudad)  -- Relacionar con la sucursal
        FROM #temp_ventas tv
        WHERE NOT EXISTS (
            SELECT 1 
            FROM creacion.venta v
            WHERE v.id_factura = tv.ID_Factura
        );

        -- Crear tabla temporal para almacenar detalles de venta
        CREATE TABLE #temp_detalle_venta (
            id_venta INT,
            id_producto INT,
            cantidad INT,
            precio_unitario DECIMAL(10, 2)
        );

        -- Insertar datos en la tabla detalle_venta evitando duplicados
        INSERT INTO #temp_detalle_venta (id_venta, id_producto, cantidad, precio_unitario)
        SELECT 
            v.id_venta,
            p.id_producto,
            t.Cantidad,
            t.Precio_Unitario
        FROM #temp_ventas t
        INNER JOIN creacion.venta v ON t.ID_Factura = v.id_factura
        INNER JOIN creacion.producto p ON t.Producto = p.nombre_producto
        WHERE NOT EXISTS (
            SELECT 1 
            FROM creacion.detalle_venta dv
            WHERE dv.id_venta = v.id_venta AND dv.id_producto = p.id_producto
        );

        INSERT INTO creacion.detalle_venta (id_venta, id_producto, cantidad, precio_unitario)
        SELECT id_venta, id_producto, cantidad, precio_unitario FROM #temp_detalle_venta;

        DROP TABLE #temp_ventas;
        DROP TABLE #temp_detalle_venta;

        COMMIT TRANSACTION;  
        PRINT 'Datos de ventas cargados correctamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;  -- Revertir la transacción en caso de error
        PRINT 'Error al cargar los datos: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
