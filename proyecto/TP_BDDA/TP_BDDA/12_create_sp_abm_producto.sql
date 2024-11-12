USE Com2900G08
GO

DROP PROCEDURE IF EXISTS abm_producto.dar_de_alta
GO
CREATE PROCEDURE abm_producto.dar_de_alta
    @nombre_producto_par VARCHAR(150),
    @precio_par DECIMAL(10, 2),
    @categoria_par VARCHAR(100) = NULL
AS
BEGIN
    -- Verificar si el producto ya existe
    IF EXISTS (
        SELECT 1
        FROM creacion.producto
        WHERE nombre_producto = @nombre_producto_par
    )
    BEGIN
        RAISERROR('El producto con ese nombre ya existe', 16, 1);
        RETURN;
    END

    -- Declaración del ID del catálogo y la categoría
    DECLARE @id_catalogo INT;
    DECLARE @categoria VARCHAR(100);

    -- Si la categoría es NULL, asignar 'otros' y el id_catalogo correspondiente
    IF @categoria_par IS NULL
    BEGIN
        SET @categoria = 'Sin categoria';
        SET @id_catalogo = 10;
    END
    ELSE
    BEGIN
        SET @categoria = @categoria_par;

        -- Verificar si la categoría existe en catalogo_producto
        IF NOT EXISTS (
            SELECT 1
            FROM creacion.catalogo_producto
            WHERE tipo_catalogo = @categoria
        )
        BEGIN
            -- Insertar la categoría en caso de que no exista y obtener el nuevo ID
            INSERT INTO creacion.catalogo_producto (tipo_catalogo)
            VALUES (@categoria);

            SET @id_catalogo = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            -- Si la categoría ya existe, obtener el ID correspondiente
            SELECT @id_catalogo = id_catalogo_producto
            FROM creacion.catalogo_producto
            WHERE tipo_catalogo = @categoria;
        END
    END

    -- Insertar el producto en la tabla producto con el ID de categoría
    INSERT INTO creacion.producto (nombre_producto, precio, categoria, id_catalogo)
    VALUES (@nombre_producto_par, @precio_par, @categoria, @id_catalogo);
END;
GO
	
DROP PROCEDURE IF EXISTS abm_producto.dar_de_baja
GO
CREATE PROCEDURE abm_producto.dar_de_baja
	@nombre_producto_par VARCHAR(100)
AS
BEGIN
	IF EXISTS(
					SELECT 1
					FROM creacion.producto
					WHERE nombre_producto = @nombre_producto_par
				)
	BEGIN
		DELETE FROM creacion.producto
		WHERE nombre_producto = @nombre_producto_par
	END
	ELSE
		RAISERROR('El producto con ese nombre NO existe', 16, 1)
END
GO

DROP PROCEDURE IF EXISTS abm_producto.modificar
GO
CREATE PROCEDURE abm_producto.modificar
	@nombre_par varchar(100) = NULL,
	@precio_par decimal(10,2) = NULL,
	@categoria_par varchar(100) = NULL,
	@aBuscar_par varchar(50)
AS
BEGIN
	IF EXISTS(
				SELECT 1
				FROM creacion.producto
				WHERE nombre_producto = @aBuscar_par
			)
	BEGIN	
		UPDATE creacion.producto
		SET
			nombre_producto = COALESCE(@nombre_par, nombre_producto),
			precio = COALESCE(@precio_par, precio),
			categoria = COALESCE(@categoria_par, categoria)
		WHERE nombre_producto = @aBuscar_par
	END
	ELSE
		RAISERROR('El producto con ese nombre no existe', 16, 1)
END
GO
