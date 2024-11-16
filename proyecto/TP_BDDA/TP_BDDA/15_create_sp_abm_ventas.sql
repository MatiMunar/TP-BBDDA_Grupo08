USE Com2900G08
GO

DROP PROCEDURE IF EXISTS abm_venta.confirmar_venta
GO

CREATE PROCEDURE abm_venta.confirmar_venta
	@idVenta INT,
	@tipoFactura CHAR(1),
	@id_pago INT
AS
BEGIN
	--Verifica
	IF EXISTS(
				SELECT 1
				FROM creacion.venta
				WHERE id_venta = @idVenta
				AND estado_venta = 'Pendiente'
			)
		BEGIN
			UPDATE creacion.venta
			SET estado_venta = 'Pagada'
			WHERE id_venta = @idVenta

		-- Generar un número de factura único
        DECLARE @existeFactura BIT = 1;
        DECLARE @numeroFactura CHAR(30);
        WHILE @existeFactura = 1
			BEGIN
				EXEC utilitarias.GenerarNumeroFactura @numeroFactura OUTPUT;

				IF EXISTS (SELECT 1 FROM creacion.factura WHERE numero_factura = @numeroFactura)
					SET @existeFactura = 1;
				ELSE
					SET @existeFactura = 0;
			END;

        -- Obtener CUIT y nombre del supermercado
        DECLARE @CUIT CHAR(15);
        SELECT @CUIT = CUIT
        FROM creacion.supermercado;

        DECLARE @supermercado CHAR(30);
        SELECT @supermercado = nombre_supermercado
        FROM creacion.supermercado;

		DECLARE @total DECIMAL(10,2)
		SELECT @total = SUM(subtotal)
		FROM creacion.detalle_venta
		WHERE id_venta = @idVenta

        -- Insertar en tabla 'factura'
        INSERT INTO creacion.factura (tipo_factura, numero_factura, fecha_emision, subtotal_sin_IVA, monto_total_con_IVA, CUIT, nombre_supermercado)
        VALUES (@tipoFactura, @numeroFactura, GETDATE(), @total , @total*1.21, @CUIT, @supermercado);

        -- Obtener el id de la factura recién creada
        DECLARE @id_factura INT;
        SELECT @id_factura = id_factura
        FROM creacion.factura
        WHERE numero_factura = @numeroFactura;

        -- Insertar en tabla 'pago'
        INSERT INTO creacion.pago (id_factura, monto, fecha_pago, hora_pago, id_medio_pago)
        SELECT 
            @id_factura,
            @total*1.21,
            CONVERT(date, GETDATE()),
            CONVERT(time, GETDATE()), 
            (SELECT id_medio_pago FROM creacion.medio_de_pago WHERE id_medio_pago = @id_pago);

		-- Actualizar numeroFactura en detalle_venta
		UPDATE creacion.detalle_venta
		SET numero_factura = @numeroFactura
		WHERE id_venta = @idVenta
	END
	ELSE
		RAISERROR('No existe esa factura',16,1)
END