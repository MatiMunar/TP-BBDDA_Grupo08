USE Com2900G08
GO

--DAR ALTA
	--Funciona
	EXEC abm_sucursal.dar_alta @ciudad_par = 'Haedo', @sucursal_par = 'UNLAM' ,@direccion_par = 'AV. Rivadavia 15823', @horario_par = 'L a V 8 a.m.-2 p.m. S y D 9 a.m.-12 p.m', @telefono_par = '12345678'
	--ERROR
	EXEC abm_sucursal.dar_alta @ciudad_par = 'Villa Luzuriaga', @sucursal_par = 'UNLAM' ,@direccion_par = 'AV. Rivadavia 15823', @horario_par = 'L a V 8 a.m.-2 p.m. S y D 9 a.m.-12 p.m', @telefono_par = '123456785'

--ACTUALIZA
	--Ciudad
	EXEC abm_sucursal.modificar @ciudad_par = NULL, @sucursal_par = 'Moron', @direccion_par = NULL, @horario_par = NULL, @telefono_par = NULL, @aBuscar = 'Haedo'
	--Direccion
	EXEC abm_sucursal.modificar @ciudad_par = NULL, @sucursal_par = NULL, @direccion_par = 'Fasola 1256', @horario_par = NULL, @telefono_par = NULL, @aBuscar ='Haedo'
	--Horario
	EXEC abm_sucursal.modificar @ciudad_par = NULL,@sucursal_par = NULL, @direccion_par = NULL, @horario_par = 'L a V 8 a.m.-8 p.m. S y D 10 a.m.-2 p.m', @telefono_par = NULL, @aBuscar = 'Haedo'
	--Telefono
	EXEC abm_sucursal.modificar @ciudad_par = NULL, @sucursal_par = NULL, @direccion_par = NULL,  @horario_par = NULL,  @telefono_par = '1234-5678', @aBuscar = 'Haedo'
	--ERROR
	EXEC abm_sucursal.modificar @ciudad_par = NULL, @sucursal_par = NULL, @direccion_par = NULL, @horario_par = NULL, @telefono_par = '123456788', @aBuscar = 'Haedo'

--DAR BAJA
	--FUNCIONA
	EXEC abm_sucursal.dar_baja @ciudad_par = 'Haedo'
	--ERROR
	EXEC abm_sucursal.dar_baja @ciudad_par = 'Moron'

