USE Com2900G08
GO

--DAR ALTA
	--FUNCIONA
	EXEC abm_producto.dar_de_alta  @nombre_producto_par = 'Chocolate ABM', @precio_par = '1500', @categoria_par =  NULL
	--ERROR
	EXEC abm_producto.dar_de_alta @nombre_producto_par = 'Chocolate ABM', @precio_par = '2', @categoria_par = 'Comida'

--MODIFICAR
	--NOMBRE
	EXEC abm_producto.modificar @nombre_par = 'Chocolate A-B-M', @precio_par = NULL, @categoria_par = NULL, @aBuscar_par = 'Chocolate ABM' 
	--PRECIO
	EXEC abm_producto.modificar @nombre_par = NULL,@precio_par = 5.23, @categoria_par = NULL, @aBuscar_par = 'Chocolate A-B-M'
	--CATEGORIA
	EXEC abm_producto.modificar @nombre_par = NULL, @precio_par = NULL, @categoria_par = 'Reposteria', @aBuscar_par = 'Chocolate A-B-M'

--DAR BAJA
	--FUNCIONA
	EXEC abm_producto.dar_de_baja @nombre_producto_par = 'Chocolate A-B-M'
	--ERROR
	EXEC abm_producto.dar_de_baja @nombre_producto_par = 'Chocolate A-B-M'