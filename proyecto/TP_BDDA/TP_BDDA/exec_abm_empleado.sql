USE Com2900G08
GO

select * from creacion.empleado

--DAR DE ALTA
	--FUNCIONA
	EXEC abm_empleado.dar_de_alta 257038, 'Felipe Pedro DEVALLE', 44938169, 'Av. Ridavadavia 15682, Haedo, Buenos Aires', 'fdevalle@unlam.com', 'fdevalle@superA.com', 'Cajero', 'Ramos Mejia', 'TT'
	--ERROR(mismo legajo)
	EXEC abm_empleado.dar_de_alta 257038, 'Matias Pedro MUNAR', 44123895, 'Av. De Mayo 1562, Ramos, Buenos Aires', 'mmunar@unlam.com', 'mmunar@superA.com', 'Cajero', 'Ramos Mejia', 'TM'
	--ERROR(mismo dni)
	EXEC abm_empleado.dar_de_alta 257040, 'Matias Pedro MUNAR', 44938169, 'Av. De Mayo 1562, Ramos, Buenos Aires', 'mmunar@unlam.com', 'mmunar@superA.com', 'Cajero', 'Ramos Mejia', 'TM'
--DAR DE BAJA
	--FUNCIONA
	EXEC abm_empleado.dar_de_baja 257038
	--ERROR(no existe el legajo)
	EXEC abm_empleado.dar_de_baja 257103
--MODIFICAR
	--LEGAJO
	EXEC abm_empleado.modificar 2,null,null,null,null,null,null,null,257038
	--NOMBRE
	EXEC abm_empleado.modificar null,'Fepeli Pedro DEVALLE',null,null,null,null,null,null,2
	--DNI
	EXEC abm_empleado.modificar null,null,12345678, null,null,null,null,null,2
	--DIRECCION
	EXEC abm_empleado.modificar null,null,null,'Libertad 486', null,null,null,null,2
	--EMAIL PERSONAL
	EXEC abm_empleado.modificar null,null,null,null, 'felipedevalle@unlam.com',null,null,null,2
	--EMAIL EMPRESA
	EXEC abm_empleado.modificar null,null,null,null, null,'felipedevalle@superA.com',null,null,2
	--CARGO
	EXEC abm_empleado.modificar null,null,null,null, null,null,'Supervisor',null,2
	--TURNO
	EXEC abm_empleado.modificar null,null,null,null, null,null,null,'TM',2
	--ERROR(No existe el empleado)
	EXEC abm_empleado.modificar 2,null,null,null,null,null,null,null,234567
