USE Com2900G08



DROP PROCEDURE IF EXISTS abm_empleado.dar_de_alta
go
CREATE procedure abm_empleado.dar_de_alta
	@legajo_par int,
	@nombre_par varchar(100),
	@dni_par int,
	@direccion_par varchar(150),
	@email_personal_par varchar(100),
	@email_empresa_par varchar(100),
	@cargo_par varchar(50),
	@sucursal_par varchar(100),
	@turno_par varchar(50)
as
BEGIN
	if not exists (
					select 1 
					from creacion.empleado
					where legajo = @legajo_par
					)
	BEGIN
	declare @id_sucursal int
	select @id_sucursal = id_sucursal
	from creacion.sucursal
	where ciudad = @sucursal_par

	insert creacion.empleado (legajo,nombre,dni,direccion,email_personal,email_empresa,cargo,sucursal,turno, id_sucursal) 
	values (@legajo_par,@nombre_par,@dni_par,@direccion_par,@email_personal_par,@email_empresa_par,@cargo_par,@sucursal_par,@turno_par,@id_sucursal)
	End
	Else
		print 'El empleado ya existe'
end
	
DROP PROCEDURE IF EXISTS abm_emplado.dar_de_baja
go
create procedure abm_empleado.dar_de_baja
	@legajo_par varchar(50)
as
BEGIN
	if exists(
					select 1
					from creacion.empleado
					where legajo = @legajo_par
				)
	BEGIN
	delete from creacion.empleado
	where legajo = @legajo_par
	end
	Else
		print 'El empleado no existe'
END

DROP PROCEDURE IF EXISTS abm_empleado.modificar
go
create procedure abm_empleado.modificar
	@nombreViejo varchar(100),
	@nombreNuevo varchar(100)
as
BEGIN 
	if exists (
				select 1
				from creacion.empleado
				where nombre = @nombreViejo
				)
	BEGIN
		update creacion.empleado
		set nombre = @nombreNuevo
	END
	Else
		print 'El empleado no existe'
END
