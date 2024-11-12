USE Com2900G08
GO


--DAR DE ALTA
	--FUNCIONA
	EXEC abm_empleado.dar_de_alta 257038, 'Felipe Pedro DEVALLE', 44938169, 'Av. Ridavadavia 15682, Haedo, Buenos Aires', 'fdevalle@unlam.com', 'fdevalle@superA.com', 'Cajero', 'Ramos Mejia', 'TT'
	--ERROR(mismo legajo)
	EXEC abm_empleado.dar_de_alta 257038, 'Matias Pedro MUNAR', 44123895, 'Av. De Mayo 1562, Ramos, Buenos Aires', 'mmunar@unlam.com', 'mmunar@superA.com', 'Cajero', 'Ramos Mejia', 'TM'

--DAR DE BAJA
	--FUNCIONA
	EXEC abm_empleado.dar_de_baja 257038
	--ERROR(no existe el legajo)
	EXEC abm_empleado.dar_de_baja 257103
--MODIFICAR
	--LEGAJO
	EXEC abm_empleado.modificar 2,NULL,NULL,NULL,257038
	--CARGO
	EXEC abm_empleado.modificar NULL,NULL,'Supervisor',NULL,2
	--TURNO
	EXEC abm_empleado.modificar NULL,NULL, NULL,'TM',2
	--NOMBRE
	EXEC abm_empleado.modificar NULL,'Pedro Devalle',NULL, NULL,2
	--ERROR(No existe el empleado)
	EXEC abm_empleado.modificar 2,NULL,NULL,NULL,234567
