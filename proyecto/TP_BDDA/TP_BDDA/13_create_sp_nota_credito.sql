USE Com2900G08;
GO

DROP PROCEDURE IF EXISTS insertar.generar_nota_credito;
GO

CREATE OR ALTER PROCEDURE insertar.generar_nota_credito
    @id_factura CHAR(30),
    @valor DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRANSACTION;

    -- Validamos que el usuario que lo ejecuta sea un Supervisor
    IF IS_ROLEMEMBER('Supervisor') = 0 AND IS_ROLEMEMBER('db_owner') = 0
    BEGIN
        RAISERROR('No tiene permisos para generar una nota de crédito.', 16, 1);
        ROLLBACK TRANSACTION; -- Rollback si el usuario no tiene permisos
        RETURN;
    END;

	IF EXISTS (SELECT 1 FROM creacion.nota_credito WHERE id_factura = @id_factura)
    BEGIN
        RAISERROR('Ya existe una nota de crédito para esta factura.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    DECLARE @estado_factura CHAR(20);

    SELECT @estado_factura = estado_venta
    FROM creacion.detalle_venta DV
    INNER JOIN creacion.venta V ON DV.id_venta = V.id_venta
    WHERE V.id_factura = @id_factura;

    IF @estado_factura <> 'Pagada'
    BEGIN
        RAISERROR('Solo se pueden emitir notas de crédito para ventas pagadas.', 16, 1);
        ROLLBACK TRANSACTION; -- Rollback en caso de error
        RETURN;
    END;

    -- Insertar la nota de crédito en la tabla nota_credito
    INSERT INTO creacion.nota_credito (id_factura, valor, fecha_emision)
    VALUES (@id_factura, @valor, GETDATE());

	-- Actualizar el estado de la venta a 'Nota de Credito'
    UPDATE DV
    SET DV.estado_venta = 'Nota de Credito'
    FROM creacion.detalle_venta DV
    INNER JOIN creacion.venta V ON DV.id_venta = V.id_venta
    WHERE V.id_factura = @id_factura;

    COMMIT TRANSACTION;

    PRINT 'Nota de crédito generada exitosamente.';
END;
GO
