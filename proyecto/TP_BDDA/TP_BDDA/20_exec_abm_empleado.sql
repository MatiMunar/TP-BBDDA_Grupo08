USE Com2900G08
GO

--DAR DE ALTA
	--FUNCIONA
	EXEC abm_empleado.dar_de_alta @legajo_par = 257038, @nombre_par = 'Felipe Pedro DEVALLE',@dni_par = 44938169, @direccion_par = 'Av. Ridavadavia 15682, Haedo, Buenos Aires', @email_personal_par = 'fdevalle@unlam.com',@email_empresa_par = 'fdevalle@superA.com',@cargo_par = 'Cajero', @sucursal_par = 'Ramos Mejia', @turno_par = 'TT'
	--ERROR(mismo legajo)
	EXEC abm_empleado.dar_de_alta @legajo_par = 257038, @nombre_par = 'Matias Pedro MUNAR',@dni_par=  44123895, @direccion_par = 'Av. De Mayo 1562, Ramos, Buenos Aires',@email_personal_par = 'mmunar@unlam.com',@email_empresa_par = 'mmunar@superA.com', @cargo_par = 'Cajero', @sucursal_par = 'Ramos Mejia', @turno_par = 'TM'

--MODIFICAR
	--LEGAJO
	EXEC abm_empleado.modificar @legajo_par = 2,@nombre_par= NULL, @cargo_par = NULL,@turno_par =NULL, @legajo_buscar = 257038 -- Legajo nuevo, nombre, cargo, turno, legajo a buscar
	--CARGO
	EXEC abm_empleado.modificar @legajo_par=NULL,@nombre_par = NULL,@cargo_par='Supervisor',@turno_par= NULL,@legajo_buscar = 2
	--TURNO
	EXEC abm_empleado.modificar @legajo_par = NULL, @nombre_par = NULL,@cargo_par = NULL,@turno_par = 'TM',@legajo_buscar = 2
	--NOMBRE
	EXEC abm_empleado.modificar @legajo_par = NULL,@nombre_par = 'Pedro Devalle', @cargo_par = NULL, @turno_par = NULL,@legajo_buscar = 2
	--ERROR(No existe el empleado)
	EXEC abm_empleado.modificar @legajo_par = 2,@nombre_par = NULL, @cargo_par = NULL,@turno_par = NULL, @legajo_buscar = 234567

--DAR DE BAJA
	--FUNCIONA
	EXEC abm_empleado.dar_de_baja @legajo_par = 2
	--ERROR(no existe el legajo)
	EXEC abm_empleado.dar_de_baja @legajo_par = 257103
