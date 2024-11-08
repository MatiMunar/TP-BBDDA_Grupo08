USE Com2900G08
GO

select * from creacion.detalle_venta

DROP PROCEDURE IF exists abm_sucursal.dar_alta
go
CREATE PROCEDURE abm_sucursal.dar_alta
	@nombre_par varchar(50),
	@ciudad_par varchar(50)
AS 
BEGIN
	if not exists(
				select 1
				from creacion.sucursal
				where nombre = @nombre_par
				)
	BEGIN
	insert creacion.sucursal 
	values (@nombre_par, @ciudad_par)
	END
	ELSE
		print 'Ya existe la sucursal'
END

DROP PROCEDURE IF exists abm_sucursal.dar_baja
go
CREATE PROCEDURE abm_sucursal.dar_baja
	@nombre_par varchar(50)
AS
BEGIN
	if exists(
				select 1
				from creacion.sucursal
				where nombre = @nombre_par
			)
	BEGIN
	delete from creacion.sucursal
	where nombre = @nombre_par
	END
	ELSE
		print 'No existe la sucursal'
END

DROP PROCEDURE IF exists abm_sucursal.modificar
GO
CREATE PROCEDURE abm_sucursal.modificar
	@nombre_par varchar(50) = null,
	@ciudad_par varchar(50) = null,
	@aBuscar varchar(50)
AS
BEGIN
	if not exists(
					select 1
					from creacion.sucursal
					where nombre = @aBuscar
				)
	BEGIN
		update creacion.sucursal
		set
			nombre = coalesce(@nombre_par, nombre),
			ciudad = coalesce(@ciudad_par, ciudad)
		where nombre = @aBuscar
	END
	ELSE
		print 'No existe la sucursal'
END