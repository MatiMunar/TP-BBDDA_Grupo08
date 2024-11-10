USE Com2900G08
GO

select * from
creacion.sucursal

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
	where sucursal = @sucursal_par

	insert creacion.empleado (legajo,nombre,dni,direccion,email_personal,email_empresa,cargo,turno, id_sucursal) 
	values (@legajo_par,@nombre_par,@dni_par,@direccion_par,@email_personal_par,@email_empresa_par,@cargo_par,@turno_par,@id_sucursal)
	End
	Else
	RAISERROR('El empleado ya existe', 16, 1);
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
		RAISERROR('El empleado no existe', 16, 1);
END

DROP PROCEDURE IF EXISTS abm_empleado.modificar
go
create procedure abm_empleado.modificar
	@legajo_par int = null,
	@nombre_par char(100)= null,
	@dni_par int = null,
	@direccion_par char(150) = null,
	@email_personal_par char(100) = null,
	@email_empresa_par char(100) = null,
	@cargo_par char(50) = null,
	@turno_par char(50) = null,
	@legajo_buscar int
as
BEGIN 
	if exists (
				select 1
				from creacion.empleado
				where legajo = @legajo_buscar
				)
	BEGIN
	DECLARE @id_sucural int
	select @id_sucural = id_sucursal
	from creacion.empleado
	where legajo = @legajo_buscar

		update creacion.empleado
		set 
			legajo = coalesce(@legajo_par, legajo),
			nombre = coalesce(@nombre_par, nombre),
			dni = coalesce(@dni_par, dni),
			direccion = coalesce(@direccion_par, direccion),
			email_personal = coalesce(@email_personal_par, email_personal),
			email_empresa = coalesce(@email_empresa_par, email_empresa),
			cargo = coalesce(@cargo_par, cargo),
			turno = coalesce(@turno_par, turno),
			id_sucursal = @id_sucural
			where legajo = @legajo_buscar
	END
	Else
		RAISERROR('El empleado no existe', 16, 1);
END

select * from creacion.empleado