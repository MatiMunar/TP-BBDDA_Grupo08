USE Com2900G08
GO

--DAR ALTA
	--FUNCIONA
	EXEC abm_producto.dar_de_alta 'Chocolate ABM', '1500', NULL
	--ERROR
	EXEC abm_producto.dar_de_alta 'Chocolate ABM', '2', 'Comida'

--DAR BAJA
	--FUNCIONA
	EXEC abm_producto.dar_de_baja 'Chocolate ABM'
	--ERROR
	EXEC abm_producto.dar_de_baja 'Chocolate ABM'

--MODIFICAR
	--NOMBRE
	EXEC abm_producto.modificar 'Chocolate A-B-M', NULL,NULL,'Chocolate ABM'
	--PRECIO
	EXEC abm_producto.modificar NULL,5.23,NULL, 'Chocolate A-B-M'
	--CATEGORIA
	EXEC abm_producto.modificar NULL,NULL,'Reposteria', 'Chocolate A-B-M'