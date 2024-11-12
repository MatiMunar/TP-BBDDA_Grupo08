USE Com2900G08
GO


--DAR ALTA
	--FUNCIONA
	EXEC abm_catalogo_producto.dar_alta 'Carniceria'
	--ERROR
	EXEC abm_catalogo_producto.dar_alta 'Almacen'

--DAR BAJA
	--FUNCIONA
	EXEC abm_catalogo_producto.dar_de_baja 'Carniceria'
	--ERROR
	EXEC abm_catalogo_producto.dar_de_baja 'Carnieria'

--MODIFICAR
	--FUNCIONA
	EXEC abm_catalogo_producto.modificar 'Almacenes','Almacen'
	--FUNCIONA
	EXEC abm_catalogo_producto.modificar 'Almacen','Almacenes'
	--ERROR
	EXEC abm_catalogo_producto.modificar 'Almacen','Almacenes'