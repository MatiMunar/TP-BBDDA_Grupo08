USE Com2900G08
GO

select * from creacion.venta
select * from creacion.detalle_venta
select * from creacion.nota_credito

--DAR ALTA
	--FUNCIONA
	EXEC abm_venta.dar_de_alta 'A','11-11-2024', '10:25:35', 'Member', 'Male', 'Efectivo', '123-45-671', 2, 6, 3
	EXEC abm_venta.dar_de_alta 'A','11-11-2024', '10:25:35', 'Member', 'Male', 'Efectivo', '123-45-680',3, 2, 15

--DAR BAJA
	EXEC abm_venta.dar_de_baja '123-45-671'