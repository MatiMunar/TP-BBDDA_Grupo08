USE Com2900G08
GO

--DAR DE ALTA
	--FUNCIONA
	EXEC abm_detalle_venta.dar_de_alta 32,12,'355-53-5943'
	--ERROR
	EXEC abm_detalle_venta.dar_de_alta 32,12,'123-54-176'
	--ERROR
	EXEC abm_detalle_venta.dar_de_alta 6800,12,'355-53-5943' -- Busca la 6800 que no existe y falla porque devuelve nulo

--MODIFICAR
	--PRODUCTO
	EXEC abm_detalle_venta.modificar 2,NULL, 4
	--CANTIDAD
	EXEC abm_detalle_venta.modificar NULL,1, 4

--DAR DE BAJA
	--FUNCIONA
	EXEC abm_detalle_venta.dar_de_baja 5
	--ERROR
	EXEC abm_detalle_venta.dar_de_baja 6