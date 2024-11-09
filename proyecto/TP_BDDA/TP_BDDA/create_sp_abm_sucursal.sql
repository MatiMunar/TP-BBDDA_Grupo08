USE Com2900G08
GO

select * from creacion.detalle_venta

DROP PROCEDURE IF exists abm_sucursal.dar_alta
go
CREATE PROCEDURE abm_sucursal.dar_alta
	@ciudad_par varchar(100),
	@direccion_par varchar(100),
	@horario_par varchar(50),
	@telefono_par varchar(9)
AS 
BEGIN
	if not exists(
				select 1
				from creacion.sucursal
				where ciudad = @ciudad_par
				)
	BEGIN
	insert creacion.sucursal 
	values (@ciudad_par, @direccion_par, @horario_par, @telefono_par)
	END
	ELSE
		print 'Ya existe la sucursal'
END

DROP PROCEDURE IF exists abm_sucursal.dar_baja
go
CREATE PROCEDURE abm_sucursal.dar_baja
	@ciudad_par varchar(100)
AS
BEGIN
	if exists(
				select 1
				from creacion.sucursal
				where ciudad = @ciudad_par
			)
	BEGIN
	delete from creacion.sucursal
	where ciudad = @ciudad_par
	END
	ELSE
		print 'No existe la sucursal'
END

DROP PROCEDURE IF exists abm_sucursal.modificar
GO
CREATE PROCEDURE abm_sucursal.modificar
	@ciudad_par varchar(100) = null,
	@direccion_par varchar(100)= null,
	@horario_par varchar(100) = null,
	@telefono_par varchar(9) = null,
	@aBuscar varchar(50)
AS
BEGIN
	if exists(
					select 1
					from creacion.sucursal
					where ciudad = @aBuscar
				)
	BEGIN
	DECLARE @telefono_actual VARCHAR(9);
    SELECT @telefono_actual = telefono
    FROM creacion.sucursal
    WHERE ciudad = @aBuscar;
	SET @telefono_par = COALESCE(@telefono_par, @telefono_actual);
	update creacion.sucursal
	set
		ciudad = coalesce(@ciudad_par, ciudad),
		direccion = coalesce(@direccion_par, direccion),
		horario = coalesce(@horario_par, horario)
	where ciudad = @aBuscar
		IF @telefono_par is not null
		BEGIN
			UPDATE creacion.sucursal
            SET telefono = @telefono_par
            WHERE ciudad = @aBuscar;
		END
	END
	ELSE
		print 'No existe la sucursal'
END
