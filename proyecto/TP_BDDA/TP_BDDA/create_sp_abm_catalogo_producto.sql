USE Com2900G08
go


DROP PROCEDURE IF exists abm_catalogo_producto.dar_alta
GO
CREATE PROCEDURE abm_catalogo_producto.dar_alta
	@catalogo_par varchar(50)
AS
BEGIN
	if not exists(
					select 1
					from creacion.catalogo_producto
					where tipo_catalogo = @catalogo_par
				)
	BEGIN
		INSERT creacion.catalogo_producto (tipo_catalogo)
		values (@catalogo_par)
	END
	ELSE
		print 'Ya existe esta categoria'
END

DROP PROCEDURE IF exists abm_catalogo_producto.dar_de_baja
GO
CREATE PROCEDURE abm_catalogo_producto.dar_de_baja
	@catalogo_par varchar(50)
AS
BEGIN
	if exists(
					select 1
					from creacion.catalogo_producto
					where tipo_catalogo = @catalogo_par
				)
	BEGIN
		DELETE FROM creacion.catalogo_producto
		where tipo_catalogo = @catalogo_par
	END
	ELSE
		print 'No existe esta categoria'
END

DROP PROCEDURE IF exists abm_catalogo_producto.modificar
GO
CREATE PROCEDURE abm_catalogo_producto.modificar
	@catalogo_par varchar(50),
	@aBuscar varchar(50)
AS
BEGIN
	if exists(
				select 1
				from creacion.catalogo_producto
				where tipo_catalogo = @aBuscar
			)
	BEGIN
		update creacion.catalogo_producto
		set tipo_catalogo = @catalogo_par
	END
	ELSE
		print 'No existe esta categoria'
END