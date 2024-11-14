USE Com2900G08
GO

--DAR ALTA
	--FUNCIONA
	EXEC abm_producto.dar_de_alta 'Chocolate ABM', '1500', NULL -- Si categor�a es NULL le pone 'Sin categor�a'
	--ERROR
	EXEC abm_producto.dar_de_alta 'Chocolate ABM', '2', 'Comida'

--MODIFICAR
	--NOMBRE
	EXEC abm_producto.modificar 'Chocolate A-B-M', NULL,NULL,'Chocolate ABM' -- Nombre nuevo de producto, precio, categor�a, producto a buscar
	--PRECIO
	EXEC abm_producto.modificar NULL,5.23,NULL, 'Chocolate A-B-M'
	--CATEGORIA
	EXEC abm_producto.modificar NULL,NULL,'Reposteria', 'Chocolate A-B-M'

--DAR BAJA
	--FUNCIONA
	EXEC abm_producto.dar_de_baja 'Chocolate A-B-M'
	--ERROR
	EXEC abm_producto.dar_de_baja 'Chocolate A-B-M'