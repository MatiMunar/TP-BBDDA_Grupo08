USE Com2900G08
GO

DROP PROCEDURE IF EXISTS insertar.datos_catalogo;
GO
CREATE PROCEDURE insertar.datos_catalogo
	@rutaArchivo NVARCHAR(255),
	@rutaArchComplement NVARCHAR(255)
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

    -- Creamos una tabla temporal con la fila numerada
    WITH CTE AS (
        SELECT 
            t.id,
            t.category,
            t.name,
            TRY_CAST(t.price AS DECIMAL(8,2)) AS Price, -- Convierte a DECIMAL, o NULL si no es posible
            t.reference_price,
            t.reference_unit,
            t.date,
            ROW_NUMBER() OVER (PARTITION BY TRIM(UPPER(t.name)) ORDER BY t.id) AS RowNum
        FROM #temp_catalogo t
    )
    -- Eliminamos los duplicados manteniendo solo el primer producto por nombre y categoría
    DELETE FROM #temp_catalogo
    WHERE id IN (
        SELECT id
        FROM CTE
        WHERE RowNum > 1
    );

    -- Insertamos los datos únicos en la tabla producto
    DECLARE @sqlAux NVARCHAR(MAX);
    SET @sqlAux = N'
    INSERT INTO creacion.producto (nombre_producto, precio, categoria, id_catalogo, tipo)
        SELECT 
            TRIM(t.name),  -- Eliminamos espacios al principio y al final
            t.Price,
            TRIM(t.category),  -- Eliminamos espacios al principio y al final
            ca.id_catalogo_producto,
            ''Nacional''
        FROM #temp_catalogo t
        INNER JOIN OPENROWSET(
            ''Microsoft.ACE.OLEDB.16.0'',
            ''Excel 12.0;HDR=YES;Database=' + @rutaArchComplement + ''',
            ''SELECT * FROM [Clasificacion productos$]''
        ) AS c ON TRIM(t.category) = TRIM(c.Producto)  -- Eliminamos espacios de la categoría también
        INNER JOIN creacion.catalogo_producto ca ON ca.tipo_catalogo = c.[Línea de producto]
        WHERE NOT EXISTS (
            SELECT 1
            FROM creacion.producto p
            WHERE TRIM(UPPER(p.nombre_producto)) = TRIM(UPPER(t.name))  -- Comparamos sin distinguir entre mayúsculas y minúsculas
              AND TRIM(UPPER(p.categoria)) = TRIM(UPPER(t.category))  -- Comparamos sin distinguir entre mayúsculas y minúsculas
        )';

	EXEC sp_executesql @sqlAux;

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
    IF NOT EXISTS (SELECT 1 FROM creacion.catalogo_producto WHERE tipo_catalogo = 'Electronic accessories')
    BEGIN
        INSERT INTO creacion.catalogo_producto (tipo_catalogo)
        VALUES ('Electronic accessories');
    END
    
    CREATE TABLE #temp_electronic_accessories (
        Product NVARCHAR(150),
        [Precio Unitario en dolares] NVARCHAR(50)   -- NVARCHAR para manejar cualquier formato sin error
    );

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

    -- Insertamos los datos únicos en la tabla producto evitando duplicados
    INSERT INTO creacion.producto (nombre_producto, precio, categoria, id_catalogo, tipo)
    SELECT 
        e.Product,
        TRY_CAST(REPLACE([Precio Unitario en dolares], ',', '.') AS DECIMAL(8,2)) AS Price,
        'Electronic accessories',
        ca.id_catalogo_producto,
        'Nacional' AS tipo
    FROM (
        SELECT DISTINCT 
            e.Product,
            e.[Precio Unitario en dolares]
        FROM #temp_electronic_accessories e
    ) AS e
    INNER JOIN creacion.catalogo_producto ca ON ca.tipo_catalogo = 'Electronic accessories'
    WHERE NOT EXISTS (
        SELECT 1
        FROM creacion.producto p
        WHERE p.nombre_producto = e.Product
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
    CREATE TABLE #temp_productos_importados (
        IdProducto NVARCHAR(50),
        NombreProducto NVARCHAR(150),
        Proveedor NVARCHAR(150),
        Categoría NVARCHAR(100),
        CantidadPorUnidad NVARCHAR(100),
        PrecioUnidad NVARCHAR(50)   -- NVARCHAR para manejar cualquier formato
    );

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

    DECLARE @tasaDeCambio DECIMAL(10,4);
    SET @tasaDeCambio = insertar.obtenerTasaCambioUSD_ARS();
    IF @tasaDeCambio IS NULL
    BEGIN
        RAISERROR('No se pudo obtener la tasa de cambio de USD a ARS.', 17, 1);
        RETURN;
    END;

    PRINT 'La tasa de cambio USD a ARS es: ' + CAST(@tasaDeCambio AS NVARCHAR(20));

    -- Eliminamos duplicados, manteniendo solo una fila por nombre de producto
    DELETE FROM #temp_productos_importados
    WHERE IdProducto NOT IN (
        SELECT MIN(IdProducto)  -- Nos quedamos con el primer registro por NombreProducto
        FROM #temp_productos_importados
        GROUP BY TRIM(UPPER(NombreProducto))  -- Agrupamos por NombreProducto
    );

    -- Insertar los datos únicos en la tabla producto
    INSERT INTO creacion.producto (nombre_producto, precio, categoria, id_catalogo, tipo)
    SELECT 
        t.NombreProducto,
        TRY_CAST(REPLACE(t.PrecioUnidad, ',', '.') AS DECIMAL(10,2)) * CAST(@tasaDeCambio AS DECIMAL(10,4)) AS Price,
        -- Seleccionamos una de las categorías del producto (cualquiera de las existentes)
        (SELECT TOP 1 TRIM(Categoría) FROM #temp_productos_importados WHERE NombreProducto = t.NombreProducto), 
        c.id_catalogo_producto,
        'Importado'
    FROM #temp_productos_importados t
    LEFT JOIN creacion.catalogo_producto c ON c.tipo_catalogo = t.Categoría
    WHERE NOT EXISTS (
        SELECT 1
        FROM creacion.producto p
        WHERE p.nombre_producto = t.NombreProducto
    );

    -- Limpiar la tabla temporal
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

        CREATE TABLE #temp_sucursal (
            Ciudad NVARCHAR(100),
            ReemplazarPor NVARCHAR(100),
            Direccion NVARCHAR(250),
            Horario NVARCHAR(100),
            Telefono NVARCHAR(20)
        );

        -- Cargamos los datos desde la hoja 'sucursal'
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

        -- Insertamos datos en la tabla sucursal evitando duplicados
        INSERT INTO creacion.sucursal (sucursal, ciudad, direccion, horario, telefono)
        SELECT 
            ReemplazarPor,
			Ciudad,
            direccion,
			horario,
			telefono
        FROM #temp_sucursal ts
        WHERE NOT EXISTS (
            SELECT 1
            FROM creacion.sucursal s
            WHERE s.sucursal = ts.ReemplazarPor
			AND s.ciudad = ts.Ciudad
        );

        -- Creamos tabla temporal para empleados
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

        -- Cargamos datos desde la hoja 'Empleados'
        SET @sql = N'
        INSERT INTO #temp_empleado (LegajoID, Nombre, Apellido, DNI, Direccion, EmailPersonal, EmailEmpresa, CUIL, Cargo, Sucursal, Turno)
        SELECT [Legajo/ID], [Nombre], [Apellido], [DNI], [Direccion], [Email Personal], [Email Empresa], [CUIL], [Cargo], [Sucursal], [Turno]
        FROM OPENROWSET(
            ''Microsoft.ACE.OLEDB.16.0'',
            ''Excel 12.0;HDR=YES;Database=' + @rutaArchivo + ''',
            ''SELECT * FROM [Empleados$]''
        )';
        EXEC sp_executesql @sql;

		OPEN SYMMETRIC KEY ClaveEmpleado DECRYPTION BY CERTIFICATE CertificadoEmpleado;

        -- Insertamos datos en la tabla empleado evitando duplicados
        INSERT INTO creacion.empleado (nombre, legajo, id_sucursal, dni, direccion, email_personal, email_empresa, cargo, turno)
        SELECT 
            CONCAT(e.Nombre, ' ', e.Apellido),  -- Concatenar Nombre y Apellido
            e.LegajoID,                         
            s.id_sucursal,
			EncryptByKey(Key_GUID('ClaveEmpleado'), CONVERT(VARCHAR(15), e.DNI)),    -- Encriptamos DNI
			EncryptByKey(Key_GUID('ClaveEmpleado'), e.Direccion),                    -- Encriptamos Dirección
			EncryptByKey(Key_GUID('ClaveEmpleado'), e.EmailPersonal),                -- Encriptamos Email Personal
			EncryptByKey(Key_GUID('ClaveEmpleado'), e.EmailEmpresa),                 -- Encriptamos Email Empresa
			e.Cargo,
			e.Turno
        FROM #temp_empleado e
        INNER JOIN creacion.sucursal s ON e.Sucursal = s.sucursal
        WHERE NOT EXISTS (
            SELECT 1
            FROM creacion.empleado emp
            WHERE emp.legajo = e.LegajoID
        );

		CLOSE SYMMETRIC KEY ClaveEmpleado;

        -- Creamos tabla temporal para clasificacion de productos
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

        -- Insertamos datos en la tabla catalogo_producto evitando duplicados
        INSERT INTO creacion.catalogo_producto (tipo_catalogo)
        SELECT DISTINCT
            cp.LineaDeProducto
        FROM #temp_clasificacion_producto cp
		WHERE NOT EXISTS(
			SELECT 1
			FROM creacion.catalogo_producto c
			WHERE c.tipo_catalogo = cp.LineaDeProducto
		);

        DROP TABLE #temp_sucursal;
        DROP TABLE #temp_empleado;
        DROP TABLE #temp_clasificacion_producto;

        COMMIT TRANSACTION; -- Si todo salió bien commiteamos la transacción
        PRINT 'Datos cargados correctamente.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;  -- Revertimos la transacción en caso de error
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

        -- Paso 1: Creamos tabla temporal para cargar todo el CSV
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

        DECLARE @sql NVARCHAR(MAX);
        SET @sql = N'
        BULK INSERT #temp_ventas
        FROM ''' + @rutaArchivo + '''
        WITH (
            CHECK_CONSTRAINTS,
            FORMAT = ''CSV'',
            FIELDTERMINATOR = '';'',      
            ROWTERMINATOR = ''0x0D0A'',     
            FIRSTROW = 2,                
            CODEPAGE = ''65001''
        )';
        EXEC sp_executesql @sql;

        -- Obtener tasa de cambio
        DECLARE @tasaDeCambio DECIMAL(10,4);
        SET @tasaDeCambio = insertar.obtenerTasaCambioUSD_ARS();
        IF @tasaDeCambio IS NULL
        BEGIN
            RAISERROR('No se pudo obtener la tasa de cambio de USD a ARS.', 17, 1);
            RETURN;
        END;

        -- Paso 2: Creamos tabla temporal para ventas agrupadas y para el cálculo del id_venta_calculado
        CREATE TABLE #ventas_agrupadas (
            ID_Factura NVARCHAR(50),
            fecha DATE,
            hora TIME,
            id_empleado INT,
            id_sucursal INT,
            monto_total DECIMAL(18, 2),
            id_venta_calculado INT
        );

        -- Obtenemos el último id_venta en la tabla de ventas, si no existe lo inicializamos en 0
        DECLARE @last_id_venta INT;
        SELECT @last_id_venta = ISNULL(MAX(id_venta), 0) FROM creacion.venta;

        -- Insertamos datos agrupados en la tabla temporal #ventas_agrupadas con id_venta_calculado (una especie de identity)
        INSERT INTO #ventas_agrupadas (ID_Factura, fecha, hora, id_empleado, id_sucursal, monto_total, id_venta_calculado)
        SELECT 
            tv.ID_Factura,
            MIN(tv.Fecha) AS Fecha,
            MIN(tv.Hora) AS Hora,
            emp.id_empleado,
            suc.id_sucursal,
            SUM(CASE
                    WHEN p.tipo = 'Importado' THEN TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2)) * @tasaDeCambio * tv.Cantidad
                    ELSE TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2)) * tv.Cantidad
                END) * 1.21 AS monto_total, -- Aplicanmos IVA del 21%
            ROW_NUMBER() OVER (ORDER BY MIN(tv.Fecha), MIN(tv.Hora)) + @last_id_venta AS id_venta_calculado
        FROM #temp_ventas tv
        INNER JOIN creacion.empleado emp ON tv.Empleado = emp.legajo
        INNER JOIN creacion.sucursal suc ON tv.Ciudad = suc.ciudad
        INNER JOIN creacion.producto p ON tv.Producto = p.nombre_producto
        GROUP BY tv.ID_Factura, emp.id_empleado, suc.id_sucursal;

        -- Paso 3: Insertamos en venta evitando duplicados
		DECLARE @filas_insertadas INT;
        INSERT INTO creacion.venta (fecha, hora, id_empleado, id_sucursal, monto_total)
        SELECT 
            fecha,
            hora,
            id_empleado,
            id_sucursal,
            monto_total
        FROM #ventas_agrupadas va
        WHERE NOT EXISTS (
            SELECT 1 FROM creacion.venta v
            WHERE v.fecha = va.fecha 
            AND v.hora = va.hora
            AND v.id_empleado = va.id_empleado
            AND v.id_sucursal = va.id_sucursal
            AND v.monto_total = va.monto_total
        );

		-- Verificamos si no se insertaron registros para terminar la ejecución
		SET @filas_insertadas = @@ROWCOUNT;
		IF @filas_insertadas = 0
		BEGIN
			RAISERROR('No hay ventas nuevas para registrar.', 16, 1);
			RETURN;
		END;
        -- Paso 4: Insertamos en detalle_venta evitando duplicados
        INSERT INTO creacion.detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal, numero_factura)
        SELECT 
            va.id_venta_calculado AS id_venta,
            p.id_producto,
            tv.Cantidad,
            CASE
                WHEN p.tipo = 'Importado' THEN TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2)) * @tasaDeCambio
                ELSE TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2))
            END AS precio_unitario,
            CASE
                WHEN p.tipo = 'Importado' THEN (TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2)) * @tasaDeCambio) * tv.Cantidad
                ELSE (TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2)) * tv.Cantidad)
            END AS subtotal,
            tv.ID_Factura
        FROM #temp_ventas tv
        INNER JOIN creacion.producto p ON tv.Producto = p.nombre_producto
        INNER JOIN #ventas_agrupadas va ON tv.ID_Factura = va.ID_Factura
        WHERE NOT EXISTS (
            SELECT 1 FROM creacion.detalle_venta dv
            WHERE dv.id_producto = p.id_producto
            AND dv.cantidad = tv.Cantidad
            AND dv.precio_unitario = precio_unitario
            AND dv.subtotal = subtotal
            AND dv.numero_factura = tv.ID_Factura
        );

        -- Paso 5: Insertamos facturas asociadas a cada venta
        INSERT INTO creacion.factura (tipo_factura, numero_factura, IVA, subtotal_sin_IVA, monto_total_con_IVA,fecha_emision, CUIT, nombre_supermercado)
        SELECT 
            tv.Tipo_de_Factura,
            tv.ID_Factura,
            1.21, -- Aplicamos IVA del 21%
            SUM(CASE
                    WHEN p.tipo = 'Importado' THEN TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2)) * @tasaDeCambio * tv.Cantidad
                    ELSE TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2)) * tv.Cantidad
                END) AS subtotal_sin_IVA,
            SUM(CASE
                    WHEN p.tipo = 'Importado' THEN TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2)) * @tasaDeCambio * tv.Cantidad
                    ELSE TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2)) * tv.Cantidad
                END) * 1.21 AS monto_total_con_IVA,
            MIN(tv.Fecha),
			sm.CUIT,
			sm.nombre_supermercado
        FROM #temp_ventas tv
        INNER JOIN creacion.producto p ON tv.Producto = p.nombre_producto
		CROSS JOIN creacion.supermercado sm
        GROUP BY tv.Tipo_de_Factura, tv.ID_Factura, sm.CUIT, sm.nombre_supermercado;

        -- Paso 6: Insertamos en medio_de_pago
        INSERT INTO creacion.medio_de_pago (tipo_medio_pago)
        SELECT DISTINCT tv.Medio_de_Pago
        FROM #temp_ventas tv
        WHERE NOT EXISTS (
            SELECT 1 FROM creacion.medio_de_pago m WHERE tv.Medio_de_Pago = m.tipo_medio_pago
        );

        -- Paso 7: Insertamos en pagos
        INSERT INTO creacion.pago (id_factura, monto, fecha_pago, hora_pago, id_medio_pago)
        SELECT 
            f.id_factura,
            SUM(CASE 
                    WHEN p.tipo = 'Importado' THEN TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2)) * @tasaDeCambio * tv.Cantidad
                    ELSE TRY_CAST(REPLACE(tv.Precio_Unitario, ',', '.') AS DECIMAL(10,2)) * tv.Cantidad
                END) * 1.21, -- Aplicamos IVA del 21%
            MIN(tv.Fecha),
            MIN(tv.Hora),
            mp.id_medio_pago
        FROM #temp_ventas tv
        INNER JOIN creacion.factura f ON tv.ID_Factura = f.numero_factura
        INNER JOIN creacion.medio_de_pago mp ON tv.Medio_de_Pago = mp.tipo_medio_pago
        INNER JOIN creacion.producto p ON tv.Producto = p.nombre_producto
        GROUP BY f.id_factura, mp.id_medio_pago;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

DROP PROCEDURE IF EXISTS insertar.actualizar_categoria;
GO
CREATE PROCEDURE insertar.actualizar_categoria
AS
BEGIN
    -- Actualizamos los productos con categoría NULL
    UPDATE p
    SET p.categoria = 'Sin categoria',
        p.id_catalogo = 10
    FROM creacion.producto p
    WHERE p.id_catalogo IS NULL;

    PRINT 'Las categorías NULL han sido actualizadas a "Otros" con id_catalogo = 10';
END;
GO