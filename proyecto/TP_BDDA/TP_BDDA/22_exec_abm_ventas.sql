USE Com2900G08
GO

--DAR ALTA
	--FUNCIONA
	EXEC abm_venta.dar_de_alta 'A','11-11-2024', '10:25:35', 'Member', 'Male', 'Efectivo', '123-45-002', 2, 34, 7
	EXEC abm_venta.dar_de_alta 'A','11-11-2024', '10:25:35', 'Member', 'Male', 'Efectivo', '123-45-680',3, 2, 15

--MODIFICAR
	--TIPO FACTURA
	EXEC abm_venta.modificar 'C', NULL, NULL, '123-45-002'
	--MEDIO DE PAGO
	EXEC abm_venta.modificar NULL, 'EWALLET', NULL, '123-45-002'
	--ID EMPLEADO
	EXEC abm_venta.modificar NULL, NULL, 11, '123-45-002'
	--ERROR
	EXEC abm_venta.modificar 'Z', NULL, 11, '123-45-002'
	--ERROR
	EXEC abm_venta.modificar 'Z', NULL, 20, '123-45-671'
	--ERROR
	EXEC abm_venta.modificar 'Z', NULL, 20, '123-45-678'