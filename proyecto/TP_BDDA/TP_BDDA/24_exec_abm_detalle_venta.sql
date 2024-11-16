USE Com2900G08
GO

-- Crear una variable de tabla para almacenar los productos y cantidades
DECLARE @productos utilitarias.ProductoCantidadType
INSERT INTO @productos (id_producto, cantidad)
VALUES (2, 1),(4, 3), (6,5)
EXEC abm_detalle_venta.insertar_detalles @productos_cantidades = @productos, @id_empleado = 2

--DAR DE BAJA A UN SOLO DETALLE DE UNA VENTA PENDIENTE
EXEC abm_detalle_venta.dar_de_baja @id_dv = 629


--EXPLICACION:
/*	--Insertar_Detalles
	La estructura ProductoCantidadType, es una estructura que solo le pasan dos datos, (id del producto a insertar en el detalle de venta y la cantidad). 
	Al exec, se le pasa esa estructura y el id del empleado que "Escaneo" los productos. El sp, se encarga de crear los detalles de venta y de crear la venta en estado pendiente.
	--Dar_De_Baja
	Se le envia el id del detalle de venta para eliminarlo de la tabla, actualizando asi, la tabla venta (restando su valor del monto total), eliminandolo de la tabla detalle de venta y si solo ese dato (que voy a borrar) es el que esta en la tabla, borra la venta.
*/

/*ACLARACION:
	El estado actual de la venta está en pendiente, para ello se debe e*/