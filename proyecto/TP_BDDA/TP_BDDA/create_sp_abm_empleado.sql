USE Com2900G08

DROP PROCEDURE IF EXISTS abm_empleado.dar_de_alta_empleado
go
CREATE procedure abm_empleado.dar_de_alta_empleado
	@nombre_par varchar(100),
	@legajo_par varchar(50),
	@id_sucural_par int
as
BEGIN
	if not exists (
					select 1 
					from creacion.empleado
					where legajo = @legajo_par
					)
	BEGIN
	insert creacion.empleado (nombre,legajo, id_sucursal) 
	values (@nombre_par, @legajo_par, @id_sucural_par)
	End
	Else
		print 'El empleado ya existe'
end
	
DROP PROCEDURE IF EXISTS abm_emplado.dar_de_baja_empleado
go
create procedure abm_empleado.dar_de_baja_empleado
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

DROP PROCEDURE IF EXISTS abm_empleado.modificar_empleado
go
create procedure abm_empleado.modificar_empleado
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
