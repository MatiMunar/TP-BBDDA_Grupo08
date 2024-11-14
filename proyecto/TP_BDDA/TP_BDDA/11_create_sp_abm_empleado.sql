USE Com2900G08
GO

DROP PROCEDURE IF EXISTS abm_empleado.dar_de_alta
GO

CREATE PROCEDURE abm_empleado.dar_de_alta
    @legajo_par INT,
    @nombre_par VARCHAR(100),
    @dni_par INT,
    @direccion_par VARCHAR(150),
    @email_personal_par VARCHAR(100),
    @email_empresa_par VARCHAR(100),
    @cargo_par VARCHAR(50),
    @sucursal_par VARCHAR(100),
    @turno_par VARCHAR(50)
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM creacion.empleado
        WHERE legajo = @legajo_par
					)
	AND NOT EXISTS(
		SELECT 1
		FROM creacion.empleado
		WHERE dni = @dni_par
					)
    BEGIN
        DECLARE @id_sucursal INT;
        SELECT @id_sucursal = id_sucursal
        FROM creacion.sucursal
        WHERE sucursal = @sucursal_par;

        OPEN SYMMETRIC KEY ClaveEmpleado DECRYPTION BY CERTIFICATE CertificadoEmpleado;

        INSERT INTO creacion.empleado (legajo, nombre, dni, direccion, email_personal, email_empresa, cargo, turno, id_sucursal) 
        VALUES (
            @legajo_par,
            @nombre_par,
            EncryptByKey(Key_GUID('ClaveEmpleado'), CAST(@dni_par AS VARCHAR(20))),
            EncryptByKey(Key_GUID('ClaveEmpleado'), @direccion_par),
            EncryptByKey(Key_GUID('ClaveEmpleado'), @email_personal_par),
            EncryptByKey(Key_GUID('ClaveEmpleado'), @email_empresa_par),
            @cargo_par,
            @turno_par,
            @id_sucursal
        );
        CLOSE SYMMETRIC KEY ClaveEmpleado;
    END
    ELSE
    BEGIN
        RAISERROR('El empleado ya existe', 16, 1);
    END
END;
GO


DROP PROCEDURE IF EXISTS abm_empleado.dar_de_baja
GO

CREATE PROCEDURE abm_empleado.dar_de_baja
	@legajo_par VARCHAR(50)
AS
BEGIN
	IF EXISTS(
					SELECT 1
					FROM creacion.empleado
					WHERE legajo = @legajo_par
				)
	BEGIN
	DELETE FROM creacion.empleado
	WHERE legajo = @legajo_par
	END
	ELSE
		RAISERROR('El empleado no existe', 16, 1);
END
GO

DROP PROCEDURE IF EXISTS abm_empleado.modificar
GO

CREATE PROCEDURE abm_empleado.modificar
	@legajo_par INT = NULL,
	@nombre_par CHAR(100)= NULL,
	@cargo_par CHAR(50) = NULL,
	@turno_par CHAR(50) = NULL,
	@legajo_buscar INT
AS
BEGIN 
	IF EXISTS (
				SELECT 1
				FROM creacion.empleado
				WHERE legajo = @legajo_buscar
				)
	BEGIN
	DECLARE @id_sucural INT
	SELECT @id_sucural = id_sucursal
	FROM creacion.empleado
	WHERE legajo = @legajo_buscar

		UPDATE creacion.empleado
		SET 
			legajo = COALESCE(@legajo_par, legajo),
			nombre = COALESCE(@nombre_par, nombre),
			cargo = COALESCE(@cargo_par, cargo),
			turno = COALESCE(@turno_par, turno),
			id_sucursal = @id_sucural
			WHERE legajo = @legajo_buscar
	END
	ELSE
		RAISERROR('El empleado no existe', 16, 1);
END
GO
