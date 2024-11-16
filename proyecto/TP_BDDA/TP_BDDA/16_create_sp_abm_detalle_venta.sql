USE Com2900G08
GO

DROP PROCEDURE IF EXISTS abm_detalle_venta.insertar_detalles
GO

CREATE PROCEDURE abm_detalle_venta.insertar_detalles
    @id_empleado INT,
    @productos_cantidades utilitarias.ProductoCantidadType READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar que el empleado existe
        IF NOT EXISTS (
            SELECT 1
            FROM creacion.empleado
            WHERE id_empleado = @id_empleado
        )
        BEGIN
            PRINT 'Error: El empleado no existe en la tabla creacion.empleado.';
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Verificar que todos los productos existen
        IF EXISTS (
            SELECT 1
            FROM @productos_cantidades pc
            LEFT JOIN creacion.producto p ON pc.id_producto = p.id_producto
            WHERE p.id_producto IS NULL
        )
        BEGIN
            PRINT 'Error: Uno o más productos no existen en la tabla creacion.producto.';
            ROLLBACK TRANSACTION;
            RETURN;
        END;
		-- Verificar que todas las cantidades sean positivas
		IF EXISTS (
				SELECT 1
				FROM @productos_cantidades pc
				WHERE cantidad <= 0
		)
		BEGIN
            PRINT 'Error: Las cantidades ingresadas no son positivas';
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Obtener id_sucursal del empleado
        DECLARE @id_sucursal INT;
        SELECT @id_sucursal = id_sucursal
        FROM creacion.empleado
        WHERE id_empleado = @id_empleado;

        -- Calcular el total
        DECLARE @total DECIMAL(10,2) = 0;
        SELECT @total = SUM(pc.cantidad * p.precio)
        FROM @productos_cantidades pc
        JOIN creacion.producto p ON p.id_producto = pc.id_producto;

        -- Insertar en tabla 'venta'
        INSERT INTO creacion.venta (id_sucursal, id_empleado, fecha, hora, monto_total, estado_venta)
        VALUES (@id_sucursal, @id_empleado, CONVERT(date, GETDATE()), CONVERT(time, GETDATE()), @total*1.21, 'Pendiente');

		DECLARE @id_venta INT;
        SELECT @id_venta = MAX(id_venta)
        FROM creacion.venta;

        -- Insertar en tabla 'detalle_venta'
        INSERT INTO creacion.detalle_venta (id_venta, id_producto, precio_unitario, cantidad, subtotal)
        SELECT 
            @id_venta,
            pc.id_producto,
            p.precio AS precio_unitario,
            pc.cantidad,
            (pc.cantidad * p.precio) AS subtotal
        FROM @productos_cantidades pc
        JOIN creacion.producto p ON p.id_producto = pc.id_producto;

        -- Confirmar transacción si todo fue exitoso
        COMMIT TRANSACTION;

        PRINT 'Detalles de venta insertados exitosamente.';
    END TRY
    BEGIN CATCH
        -- En caso de error, deshacer la transacción
        ROLLBACK TRANSACTION;

        -- Capturar y mostrar el error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO


DROP PROCEDURE IF EXISTS abm_detalle_venta.dar_de_baja
GO

CREATE PROCEDURE abm_detalle_venta.dar_de_baja
    @id_dv INT
AS
BEGIN
    DECLARE @id_venta INT
    SELECT @id_venta = id_venta
    FROM creacion.detalle_venta
    WHERE id_detalle_venta = @id_dv

    IF EXISTS (
        SELECT 1
        FROM creacion.venta
        WHERE id_venta = @id_venta
        AND estado_venta = 'Pendiente'
    )
    BEGIN
        DECLARE @monto DECIMAL (10,2)
        SELECT @monto = subtotal
        FROM creacion.detalle_venta
        WHERE id_detalle_venta = @id_dv

        -- Restar el monto al total de la venta
        UPDATE creacion.venta
        SET monto_total = monto_total - @monto
        WHERE id_venta = @id_venta

        -- Eliminar el detalle de venta
        DELETE FROM creacion.detalle_venta
        WHERE id_detalle_venta = @id_dv

        -- Verificar si ya no hay detalles de venta asociados a esta venta
        IF NOT EXISTS (
            SELECT 1
            FROM creacion.detalle_venta
            WHERE id_venta = @id_venta
        )
        BEGIN
            -- Si no hay más detalles, eliminar la venta completamente
            DELETE FROM creacion.venta
            WHERE id_venta = @id_venta
        END
    END
    ELSE
    BEGIN
        RAISERROR('No existe el detalle de venta', 16, 1)
    END
END
GO

