USE Com2900G08
GO

--DAR ALTA
	--FUNCIONA
	EXEC abm_catalogo_producto.dar_alta @catalogo_par = 'Carniceria'
	--ERROR
	EXEC abm_catalogo_producto.dar_alta @catalogo_par = 'Almacen'

--DAR BAJA
	--FUNCIONA
	EXEC abm_catalogo_producto.dar_de_baja @catalogo_par = 'Carniceria'
	--ERROR
	EXEC abm_catalogo_producto.dar_de_baja @catalogo_par = 'Carnieria'

--MODIFICAR
	--FUNCIONA
	EXEC abm_catalogo_producto.modificar @catalogo_par = 'Almacenes', @aBuscar = 'Almacen'
	--FUNCIONA
	EXEC abm_catalogo_producto.modificar @catalogo_par = 'Almacen', @aBuscar = 'Almacenes'
	--ERROR
	EXEC abm_catalogo_producto.modificar @catalogo_par = 'Almacen', @aBuscar = 'Almacenes'