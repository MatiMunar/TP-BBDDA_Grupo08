USE Com2900G08
GO

DROP PROCEDURE IF EXISTS abm_detalle_venta.dar_de_alta
GO

CREATE PROCEDURE abm_detalle_venta.dar_de_alta
	@id_producto INT,
	@cantidad INT,
	@id_factura CHAR(30)
AS
BEGIN
	IF EXISTS(
					SELECT 1
					FROM creacion.venta
					WHERE id_factura = @id_factura
				)
	BEGIN
	DECLARE @id_venta INT
	SELECT @id_venta = id_venta
	FROM creacion.venta
	WHERE id_factura = @id_factura

	DECLARE @precio_unitario DECIMAL(10,2)
	SELECT @precio_unitario = precio
	FROM creacion.producto
	WHERE id_producto = @id_producto

	INSERT creacion.detalle_venta (id_venta, id_producto, cantidad,precio_unitario)
	VALUES (@id_venta, @id_producto, @cantidad, @precio_unitario)
	END
	ELSE
		RAISERROR('La factura no existe', 16,1)
END
GO

DROP PROCEDURE IF EXISTS abm_detalle_venta.dar_de_baja
GO

CREATE PROCEDURE abm_detalle_venta.dar_de_baja
	@id_dv INT
AS
BEGIN
	IF EXISTS (
				SELECT 1
				FROM creacion.detalle_venta
				WHERE id_detalle_venta = @id_dv
				AND estado_venta = 'Pagada'
				)
	BEGIN
	DECLARE @id_factura CHAR(30)
	SELECT @id_factura = id_factura
	FROM creacion.venta v
	INNER JOIN creacion.detalle_venta dv ON v.id_venta = dv.id_venta
	WHERE dv.id_detalle_venta = @id_dv

	DECLARE @total DECIMAL(10,2)
	SELECT @total = SUM(cantidad * precio_unitario)
	FROM creacion.detalle_venta
	WHERE id_detalle_venta = @id_dv

	INSERT creacion.nota_credito (id_factura, valor,fecha_emision) VALUES (@id_factura, @total, GETDATE())
	
	UPDATE DV
    SET DV.estado_venta = 'Nota de Credito'
    FROM creacion.detalle_venta DV
    WHERE id_detalle_venta = @id_dv
	END
	ELSE
		RAISERROR('No existe el detalle de venta o no esta pago',16,1)
END
GO

DROP PROCEDURE IF EXISTS abm_detalle_venta.modificar
GO

CREATE PROCEDURE abm_detalle_venta.modificar
	@id_producto INT = NULL,
	@cantidad INT = NULL,
	@id_dv INT
AS
BEGIN
	IF EXISTS(
				SELECT 1
				FROM creacion.detalle_venta
				WHERE id_detalle_venta = @id_dv
				)
	BEGIN
		UPDATE creacion.detalle_venta
		SET
			id_producto = COALESCE(@id_producto, id_producto),
			cantidad = COALESCE(@cantidad, cantidad)
		WHERE id_detalle_venta = @id_dv
	END
	ELSE
		RAISERROR('No existe el detalle de venta',16,1)
END
GO