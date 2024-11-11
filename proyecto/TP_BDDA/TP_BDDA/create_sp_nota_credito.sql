USE Com2900G08;
GO

DROP PROCEDURE IF EXISTS insertar.insertar_nota_credito;
GO
CREATE OR ALTER PROCEDURE insertar.insertar_nota_credito
    @id_venta INT,
    @valor DECIMAL(10, 2),
    @tipo CHAR(50)
AS
BEGIN
    -- Validar que el usuario tenga el rol de Supervisor
    IF IS_ROLEMEMBER('Supervisor') = 0
    BEGIN
        RAISERROR('No tiene permisos para generar una nota de crédito.', 16, 1);
        RETURN;
    END;

    -- Validar que la venta esté pagada antes de emitir la nota de crédito
    DECLARE @estado_factura CHAR(10);

    SELECT @estado_factura = tipo_factura
    FROM creacion.venta
    WHERE id_venta = @id_venta;

	IF @estado_factura <> 'pagada'
    BEGIN
        RAISERROR('Solo se pueden emitir notas de crédito para ventas pagadas.', 16, 1);
        RETURN;
    END;
    -- Insertar la nota de crédito
    INSERT INTO creacion.nota_credito (id_venta, valor, fecha_emision, tipo)
    VALUES (@id_venta, @valor, GETDATE(), @tipo);

    PRINT 'Nota de crédito generada exitosamente.';
END;
GO
