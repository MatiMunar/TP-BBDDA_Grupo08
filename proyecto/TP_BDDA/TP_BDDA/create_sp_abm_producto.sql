USE Com2900G08

DROP PROCEDURE IF EXISTS abm_producto.dar_de_alta
go
CREATE PROCEDURE abm_producto.dar_de_alta
	@nombre_producto_par varchar(150),
	@precio_par decimal(10,2),
	@categoria_par varchar(100)
as
BEGIN
	if not exists (
					select 1
					from creacion.producto
					where nombre_producto = @nombre_producto_par
	)and exists (
					select 1
					from creacion.producto
					where categoria = @categoria_par
	)
	BEGIN
		insert creacion.producto (nombre_producto,precio,categoria)
		values (@nombre_producto_par, @precio_par, @categoria_par)
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM creacion.producto WHERE nombre_producto = @nombre_producto_par)
            PRINT 'El producto con ese nombre ya existe.'
        
        IF NOT EXISTS (SELECT 1 FROM creacion.producto WHERE categoria = @categoria_par)
            PRINT 'La categoría especificada no existe.'
	END
END

DROP PROCEDURE IF exists abm_producto.dar_de_baja
go
CREATE PROCEDURE abm_producto.dar_de_baja
	@nombre_producto_par varchar(100)
as
BEGIN
	if not exists(
					select 1
					from creacion.producto
					where nombre_producto = @nombre_producto_par
				)
	BEGIN
		delete from creacion.producto
		where nombre_producto = @nombre_producto_par
	END
	ELSE
		print 'El producto no existe'
END

DROP PROCEDURE IF exists abm_producto.modificar
GO
CREATE PROCEDURE abm_producto.modificar
	@nombre_par varchar(100) = NULL,
	@precio_par decimal(10,2) = NULL,
	@categoria_par varchar(100) = NULL,
	@aBuscar_par varchar(50)
as
BEGIN
	if exists(
				select 1
				from creacion.producto
				where nombre_producto = @aBuscar_par
			)
	BEGIN	
		UPDATE creacion.producto
		set
			nombre_producto = coalesce(@nombre_par, nombre_producto),
			precio = coalesce(@precio_par, precio),
			categoria = coalesce(@categoria_par, categoria)
		where nombre_producto = @aBuscar_par
	END
	ELSE
		print 'El producto no existe'
END

