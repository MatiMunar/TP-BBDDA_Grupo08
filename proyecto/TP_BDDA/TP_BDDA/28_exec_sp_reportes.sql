USE Com2900G08;
GO

-- Ejecutar reporte mensual
EXEC insertar.reporte_mensual @Mes = 2, @Anio = 2019;

-- Ejecutar reporte trimestral
EXEC insertar.reporte_trimestral @InicioTrimestre = '2019-01-01', @FinTrimestre = '2019-03-01';

-- Ejecutar reporte por rango de fechas
EXEC insertar.reporte_por_rango_de_fechas @FechaInicio = '2019-01-01', @FechaFin = '2019-01-31';

-- Ejecutar reporte por rango de fechas, productos vendidos por sucursal
EXEC insertar.reporte_por_sucursal @FechaInicio = '2019-01-01', @FechaFin = '2019-01-31';

-- Ejecutar reporte de los 5 productos más vendidos por semana en un mes
EXEC insertar.reporte_mas_vendidos @Year = 2019, @Month = 2;

-- Ejecutar reporte de los 5 productos menos vendidos en un mes
EXEC insertar.reporte_menos_vendidos @Year = 2019, @Month = 2;

-- Ejecutar reporte total acumulado de ventas para una fecha y sucursal específica
EXEC insertar.reporte_total_acumulado @Fecha = '2019-01-17', @SucursalID = 1;
