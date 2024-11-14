USE Com2900G08
GO

DROP PROCEDURE IF EXISTS abm_venta.dar_de_alta
GO
CREATE PROCEDURE abm_venta.dar_de_alta
	@tipo_factura CHAR(50),
	@fecha DATE,
	@hora TIME(7),
	@tipo_de_cliente CHAR(50),
	@genero CHAR(50),
	@medio_pago CHAR(50),
	@id_factura CHAR(30),
	@id_empleado INT,
	@id_producto INT,
	@cantidad INT
AS
BEGIN

	IF @tipo_factura NOT IN ('A', 'B', 'C')
    BEGIN
        RAISERROR('El tipo de factura no es válido. Debe ser A, B o C.', 16, 1);
        RETURN;
    END

	DECLARE @precio DECIMAL(10,2)
	DECLARE @id_venta INT
	DECLARE @id_sucursal INT

	 -- Obtenemos el id_sucursal asociado al empleado
    SELECT @id_sucursal = id_sucursal
    FROM creacion.empleado
    WHERE id_empleado = @id_empleado;

    -- Verificamos si ya existe una factura con el id_factura dado en la tabla 'venta'
    SELECT @id_venta = id_venta
    FROM creacion.venta
    WHERE id_factura = @id_factura;

    IF @id_venta IS NULL
    BEGIN
        -- Si no existe la factura, obtenemos el id_venta máximo y le sumamos 1
        SELECT @id_venta = ISNULL(MAX(id_venta), 0) + 1
        FROM creacion.venta;

        INSERT creacion.venta (tipo_factura, fecha, hora, tipo_cliente, genero, medio_pago, id_factura, id_empleado, id_sucursal)
        VALUES (@tipo_factura, @fecha, @hora, @tipo_de_cliente, @genero, @medio_pago, @id_factura, @id_empleado, @id_sucursal);
    END

    SELECT @precio = precio
    FROM creacion.producto
    WHERE id_producto = @id_producto;

    -- Insertar en la tabla 'detalle_venta' usando el id_venta determinado
    INSERT creacion.detalle_venta (id_venta, id_producto, cantidad, precio_unitario)
    VALUES (@id_venta, @id_producto, @cantidad, @precio);
END;
GO

DROP PROCEDURE IF EXISTS abm_venta.modificar
GO

CREATE PROCEDURE abm_venta.modificar
    @tipo_factura CHAR(50) = NULL,
    @medio_pago CHAR(50) = NULL,
    @id_empleado INT = NULL,
    @id_factura CHAR(30)
AS
BEGIN
    IF EXISTS(
        SELECT 1
        FROM creacion.venta
        WHERE id_factura = @id_factura
    )
    BEGIN
        IF @id_empleado IS NOT NULL AND NOT EXISTS (
            SELECT 1
            FROM creacion.empleado
            WHERE id_empleado = @id_empleado
        )
        BEGIN
            RAISERROR('El empleado especificado no existe', 16, 1);
            RETURN;
        END

		IF @tipo_factura NOT IN ('A', 'B', 'C')
		BEGIN
			RAISERROR('El tipo de factura no es válido. Debe ser A, B o C.', 16, 1);
			RETURN;
		END

        UPDATE creacion.venta
        SET
            tipo_factura = COALESCE(@tipo_factura, tipo_factura),
            medio_pago = COALESCE(@medio_pago, medio_pago),
            id_empleado = COALESCE(@id_empleado, id_empleado)
        WHERE id_factura = @id_factura;

    END
    ELSE
    BEGIN
        RAISERROR('La factura no existe', 16, 1);
    END
END;
GO
