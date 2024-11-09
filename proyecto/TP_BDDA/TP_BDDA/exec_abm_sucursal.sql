USE Com2900G08
GO

select * from creacion.sucursal
--DAR ALTA
	--Funciona
	EXEC abm_sucursal.dar_alta @ciudad_par = 'Haedo', @direccion_par = 'AV. Rivadavia 15823', @horario_par = 'L a V 8 a.m.-2 p.m. S y D 9 a.m.-12 p.m', @telefono_par = '12345678'
	--ERROR
	EXEC abm_sucursal.dar_alta @ciudad_par = 'Villa Luzuriaga', @direccion_par = 'AV. Rivadavia 15823', @horario_par = 'L a V 8 a.m.-2 p.m. S y D 9 a.m.-12 p.m', @telefono_par = '123456785'
--DAR BAJA
	--FUNCIONA
	EXEC abm_sucursal.dar_baja 'Haedo'
	--ERROR
	EXEC abm_sucursal.dar_baja 'Moron'
--ACTUALIZA
	--Ciudad
	EXEC abm_sucursal.modificar 'Moron',null,null,null,'Haedo'
	--Direccion
	EXEC abm_sucursal.modificar NULL,'Fasola 1256',null,null,'Moron'
	--Horario
	EXEC abm_sucursal.modificar null,null,'L a V 8 a.m.-8 p.m. S y D 10 a.m.-2 p.m',null,'Moron'
	--Telefono
	EXEC abm_sucursal.modificar null,null,null,'1234-5678','Moron'
	--ERROR
	EXEC abm_sucursal.modificar null,null,null,'123456788','Moron'