USE Com2900G08;
GO

DROP PROCEDURE IF EXISTS insertar.generar_nota_credito;
GO

CREATE OR ALTER PROCEDURE insertar.generar_nota_credito
    @numero_factura VARCHAR(30),
    @valor DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validamos que el usuario que lo ejecuta sea un Supervisor
        IF IS_ROLEMEMBER('Supervisor') = 0 AND IS_ROLEMEMBER('db_owner') = 0
        BEGIN
            RAISERROR('No tiene permisos para generar una nota de crédito.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Obtenemos el id_factura a partir del numero_factura
        DECLARE @id_factura INT;
        SELECT @id_factura = id_factura
        FROM creacion.factura
        WHERE numero_factura = @numero_factura;

        -- Verificamos si existe la factura
        IF @id_factura IS NULL
        BEGIN
            RAISERROR('El número de factura proporcionado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

		-- Verificamos si el valor pasado por parametro es positivo
		IF @valor <= 0
		BEGIN
			RAISERROR('El valor pasado por parametro debe ser mayor a 0', 16, 1);
			ROLLBACK TRANSACTION;
			RETURN;
		END;

        -- Verificamos si ya existe una nota de crédito para esa factura
        IF EXISTS (SELECT 1 FROM creacion.nota_credito WHERE id_factura = @id_factura)
        BEGIN
            RAISERROR('Ya existe una nota de crédito para esta factura.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        DECLARE @estado_venta NVARCHAR(20);

        -- Obtenemos el estado de la venta relacionada a través del numero_factura en detalle_venta
        SELECT TOP 1 @estado_venta = v.estado_venta
        FROM creacion.venta v
        INNER JOIN creacion.detalle_venta dv ON dv.id_venta = v.id_venta
        WHERE dv.numero_factura = @numero_factura;

        -- Verificamos si la venta está pagada
        IF @estado_venta <> 'Pagada'
        BEGIN
            RAISERROR('Solo se pueden emitir notas de crédito para ventas pagadas.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Calculamos el monto total de la venta asociada
        DECLARE @monto_total DECIMAL(10, 2);
        SELECT @monto_total = v.monto_total
        FROM creacion.detalle_venta dv
        INNER JOIN creacion.venta v ON dv.id_venta = v.id_venta
        WHERE dv.numero_factura = @numero_factura;

        -- Verificamos que el valor de la nota de crédito no exceda el monto total de la venta
        IF @valor > @monto_total
        BEGIN
            RAISERROR('El valor de la nota de crédito no puede exceder el monto total de la venta.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Insertamos la nota de crédito en la tabla nota_credito usando el id_factura
        INSERT INTO creacion.nota_credito (id_factura, valor, fecha_emision)
        VALUES (@id_factura, @valor, GETDATE());

        -- Actualizamos el estado de la venta a 'Nota de Crédito' basado en el numero_factura
        UPDATE v
        SET v.estado_venta = 'Nota de Credito'
        FROM creacion.venta v
        INNER JOIN creacion.detalle_venta dv ON dv.id_venta = v.id_venta
        WHERE dv.numero_factura = @numero_factura;

        COMMIT TRANSACTION;

        PRINT 'Nota de crédito generada exitosamente.';
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO