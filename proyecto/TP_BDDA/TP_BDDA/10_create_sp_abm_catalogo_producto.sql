6USE Com2900G08
GO

DROP PROCEDURE IF EXISTS abm_catalogo_producto.dar_alta
GO

CREATE PROCEDURE abm_catalogo_producto.dar_alta
	@catalogo_par varchar(50)
AS
BEGIN
	IF NOT EXISTS(
					SELECT 1
					FROM creacion.catalogo_producto
					WHERE tipo_catalogo = @catalogo_par
				)
	BEGIN
		INSERT creacion.catalogo_producto (tipo_catalogo)
		VALUES (@catalogo_par)
	END
	ELSE
		RAISERROR('Ya existe esta categoria', 16, 1)
END
GO

DROP PROCEDURE IF EXISTS abm_catalogo_producto.dar_de_baja
GO

CREATE PROCEDURE abm_catalogo_producto.dar_de_baja
	@catalogo_par varchar(50)
AS
BEGIN
	IF EXISTS(
					SELECT 1
					FROM creacion.catalogo_producto
					WHERE tipo_catalogo = @catalogo_par
				)
	BEGIN
		DELETE FROM creacion.catalogo_producto
		WHERE tipo_catalogo = @catalogo_par
	END
	ELSE
		RAISERROR('No existe esta categoria', 16, 1)
END
GO

DROP PROCEDURE IF EXISTS abm_catalogo_producto.modificar
GO

CREATE PROCEDURE abm_catalogo_producto.modificar
	@catalogo_par VARCHAR(50),
	@aBuscar VARCHAR(50)
AS
BEGIN
	IF EXISTS(
				SELECT 1
				FROM creacion.catalogo_producto
				WHERE tipo_catalogo = @aBuscar
			)
	BEGIN
		UPDATE creacion.catalogo_producto
		SET tipo_catalogo = @catalogo_par
		WHERE tipo_catalogo = @aBuscar
	END
	ELSE
		RAISERROR('No existe esta categoria', 16, 1)
END
GO