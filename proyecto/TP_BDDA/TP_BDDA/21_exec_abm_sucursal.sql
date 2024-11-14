USE Com2900G08
GO

--DAR ALTA
	--Funciona
	EXEC abm_sucursal.dar_alta @ciudad_par = 'Haedo', @sucursal_par = 'UNLAM' ,@direccion_par = 'AV. Rivadavia 15823', @horario_par = 'L a V 8 a.m.-2 p.m. S y D 9 a.m.-12 p.m', @telefono_par = '12345678'
	--ERROR
	EXEC abm_sucursal.dar_alta @ciudad_par = 'Villa Luzuriaga', @sucursal_par = 'UNLAM' ,@direccion_par = 'AV. Rivadavia 15823', @horario_par = 'L a V 8 a.m.-2 p.m. S y D 9 a.m.-12 p.m', @telefono_par = '123456785'

--ACTUALIZA
	--Ciudad
	EXEC abm_sucursal.modificar NULL,'Moron',NULL,NULL,NULL,'Haedo' -- Ciudad, Sucursal, Dirección, Horario, Teléfono, Sucursal a buscar
	--Direccion
	EXEC abm_sucursal.modificar NULL,NULL,'Fasola 1256',NULL,NULL,'Haedo'
	--Horario
	EXEC abm_sucursal.modificar NULL,NULL,NULL,'L a V 8 a.m.-8 p.m. S y D 10 a.m.-2 p.m',NULL,'Haedo'
	--Telefono
	EXEC abm_sucursal.modificar NULL,NULL,NULL,NULL,'1234-5678','Haedo'
	--ERROR
	EXEC abm_sucursal.modificar NULL,NULL,NULL,NULL,'123456788','Haedo'

--DAR BAJA
	--FUNCIONA
	EXEC abm_sucursal.dar_baja 'Haedo'
	--ERROR
	EXEC abm_sucursal.dar_baja 'Moron'

