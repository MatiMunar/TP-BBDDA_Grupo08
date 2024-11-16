USE Com2900G08

DROP PROCEDURE IF EXISTS insertar.insertar_supermercado;
GO
CREATE PROCEDURE insertar.insertar_supermercado
    @nombre_supermercado CHAR(30),
    @cuit CHAR(15)
AS
BEGIN
    -- Verificamos si el supermercado ya existe en la tabla creacion.supermercado
    IF EXISTS (
        SELECT 1
        FROM creacion.supermercado
        WHERE nombre_supermercado = @nombre_supermercado AND cuit = @cuit
    )
    BEGIN
        RAISERROR('El supermercado ya existe en la tabla.', 16, 1);
    END
    ELSE
    BEGIN
        INSERT INTO creacion.supermercado (nombre_supermercado, cuit)
        VALUES (@nombre_supermercado, @cuit);

        PRINT 'El supermercado ha sido insertado correctamente.';
    END
END;
GO
