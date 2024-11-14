USE Com2900G08
GO

DROP PROCEDURE IF EXISTS abm_sucursal.dar_alta
GO
CREATE PROCEDURE abm_sucursal.dar_alta
	@ciudad_par VARCHAR(100),
	@sucursal_par VARCHAR(100),
	@direccion_par VARCHAR(100),
	@horario_par VARCHAR(50),
	@telefono_par VARCHAR(9)
AS 
BEGIN
	IF NOT EXISTS(
				SELECT 1
				FROM creacion.sucursal
				WHERE ciudad = @ciudad_par
				)
	BEGIN
	INSERT creacion.sucursal 
	VALUES (@ciudad_par, @sucursal_par,@direccion_par, @horario_par, @telefono_par)
	END
	ELSE
		RAISERROR ('Ya existe la sucursal',16,1)
END
GO

DROP PROCEDURE IF EXISTS abm_sucursal.dar_baja
GO
CREATE PROCEDURE abm_sucursal.dar_baja
	@ciudad_par VARCHAR(100)
AS
BEGIN
	IF EXISTS(
				SELECT 1
				FROM creacion.sucursal
				WHERE ciudad = @ciudad_par
			)
	BEGIN
	DELETE FROM creacion.sucursal
	WHERE ciudad = @ciudad_par
	END
	ELSE
		RAISERROR('No existe la sucursal',16,1)
END
GO

DROP PROCEDURE IF EXISTS abm_sucursal.modificar
GO
CREATE PROCEDURE abm_sucursal.modificar
	@ciudad_par VARCHAR(100) = NULL,
	@sucursal_par VARCHAR(100) = NULL,
	@direccion_par VARCHAR(100)= NULL,
	@horario_par VARCHAR(100) = NULL,
	@telefono_par VARCHAR(9) = NULL,
	@aBuscar VARCHAR(50)
AS
BEGIN
	IF EXISTS(
					SELECT 1
					FROM creacion.sucursal
					WHERE ciudad = @aBuscar
				)
	BEGIN
	DECLARE @telefono_actual VARCHAR(9);
    SELECT @telefono_actual = telefono
    FROM creacion.sucursal
    WHERE ciudad = @aBuscar;
	SET @telefono_par = COALESCE(@telefono_par, @telefono_actual);
	UPDATE creacion.sucursal
	SET
		ciudad = COALESCE(@ciudad_par, ciudad),
		sucursal = COALESCE(@sucursal_par, sucursal),
		direccion = COALESCE(@direccion_par, direccion),
		horario = COALESCE(@horario_par, horario)
	WHERE ciudad = @aBuscar
		IF @telefono_par is not null
		BEGIN
			UPDATE creacion.sucursal
            SET telefono = @telefono_par
            WHERE ciudad = @aBuscar;
		END
	END
	ELSE
		RAISERROR('No existe la sucursal',16,1)
END
GO