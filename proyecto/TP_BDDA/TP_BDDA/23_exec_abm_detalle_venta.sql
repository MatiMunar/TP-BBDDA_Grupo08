USE Com2900G08
GO

	SELECT * FROM creacion.venta
	SELECT * FROM creacion.detalle_venta
	SELECT * FROM creacion.nota_credito

--DAR DE ALTA
	--FUNCIONA
	EXEC abm_detalle_venta.dar_de_alta 32,12,'123-45-671'
	--ERROR
	EXEC abm_detalle_venta.dar_de_alta 32,12,'123-54-176'
	--ERROR
	EXEC abm_detalle_venta.dar_de_alta 6800,12,'123-45-671'

--DAR DE BAJA
	--FUNCIONA
	EXEC abm_detalle_venta.dar_de_baja 5
	--ERROR
	EXEC abm_detalle_venta.dar_de_baja 5

--MODIFICAR
	--PRODUCTO
	EXEC abm_detalle_venta.modificar 2,NULL, 4
	--CANTIDAD
	EXEC abm_detalle_venta.modificar NULL,1, 4