USE Com2900G08;
GO

-- Reporte 1: Total facturado por días de la semana en un mes y año específicos
DECLARE @Mes INT = 2, @Anio INT = 2019;
SELECT 
    DATENAME(WEEKDAY, v.fecha) AS DiaSemana,
    SUM(dv.precio_unitario * dv.cantidad) AS TotalFacturado
FROM creacion.venta AS v
INNER JOIN creacion.detalle_venta AS dv ON v.id_venta = dv.id_venta
WHERE 
	MONTH(v.fecha) = @Mes AND YEAR(v.fecha) = @Anio
GROUP BY DATENAME(WEEKDAY, v.fecha)
FOR XML PATH('Dia'), ROOT('TotalFacturadoPorDiaDeLaSemana');
GO

-- Reporte 2: Total facturado por turnos de trabajo por mes
DECLARE @TrimestreInicio INT = 1, @TrimestreFin INT = 3, @AnioTrimestre INT = 2019;
SELECT 
    MONTH(v.fecha) AS Mes,
    e.turno AS Turno,
    SUM(dv.precio_unitario * dv.cantidad) AS TotalFacturado
FROM creacion.venta AS v
INNER JOIN creacion.detalle_venta AS dv ON v.id_venta = dv.id_venta
INNER JOIN creacion.empleado AS e ON v.id_empleado = e.id_empleado
WHERE MONTH(v.fecha) BETWEEN @TrimestreInicio AND @TrimestreFin AND YEAR(v.fecha) = @AnioTrimestre
GROUP BY MONTH(v.fecha), e.turno
ORDER BY Mes, Turno
FOR XML PATH('Mes'), ROOT('TotalFacturadoPorTurno');
GO

-- Reporte 3: Cantidad de productos vendidos en un rango de fechas (ordenado de mayor a menor)
DECLARE @FechaInicio DATE = '2019-01-01', @FechaFin DATE = '2019-2-05';
SELECT 
    p.nombre_producto AS Producto,
    SUM(dv.cantidad) AS CantidadVendida
FROM creacion.detalle_venta AS dv
INNER JOIN creacion.producto AS p ON dv.id_producto = p.id_producto
INNER JOIN creacion.venta AS v ON dv.id_venta = v.id_venta
WHERE v.fecha BETWEEN @FechaInicio AND @FechaFin
GROUP BY p.nombre_producto
ORDER BY CantidadVendida DESC
FOR XML PATH('Producto'), ROOT('ProductosVendidos');
GO

-- Reporte 4: Cantidad de productos vendidos en un rango de fechas por sucursal (ordenado de mayor a menor)
DECLARE @FechaInicio2 DATE = '2019-01-01', @FechaFin2 DATE = '2019-01-25';
SELECT 
    s.sucursal AS Sucursal,
    p.nombre_producto AS Producto,
    SUM(dv.cantidad) AS CantidadVendida
FROM creacion.detalle_venta AS dv
INNER JOIN creacion.producto AS p ON dv.id_producto = p.id_producto
INNER JOIN creacion.venta AS v ON dv.id_venta = v.id_venta
INNER JOIN creacion.sucursal AS s ON v.id_sucursal = s.id_sucursal
WHERE 
    v.fecha BETWEEN @FechaInicio2 AND @FechaFin2
GROUP BY s.sucursal, p.nombre_producto
ORDER BY CantidadVendida DESC
FOR XML PATH('Sucursal'), ROOT('ProductosVendidosPorSucursal');
GO

-- Reporte 5: Los 5 productos más vendidos en un mes, por semana
DECLARE @MesTop INT = 3, @AnioTop INT = 2019;
SELECT TOP 5
    DATEPART(WEEK, v.fecha) AS Semana,
    p.nombre_producto AS Producto,
    SUM(dv.cantidad) AS CantidadVendida
FROM creacion.detalle_venta AS dv
INNER JOIN creacion.producto AS p ON dv.id_producto = p.id_producto
INNER JOIN creacion.venta AS v ON dv.id_venta = v.id_venta
WHERE 
    MONTH(v.fecha) = @MesTop AND YEAR(v.fecha) = @AnioTop
GROUP BY DATEPART(WEEK, v.fecha), p.nombre_producto
ORDER BY Semana, CantidadVendida DESC
FOR XML PATH('Semana'), ROOT('Top5ProductosVendidos');
GO

-- Reporte 6: Los 5 productos menos vendidos en el mes
DECLARE @MesLow INT = 2, @AnioLow INT = 2019;
SELECT TOP 5
    p.nombre_producto AS Producto,
    SUM(dv.cantidad) AS CantidadVendida
FROM creacion.detalle_venta AS dv
INNER JOIN creacion.producto AS p ON dv.id_producto = p.id_producto
INNER JOIN creacion.venta AS v ON dv.id_venta = v.id_venta
WHERE 
    MONTH(v.fecha) = @MesLow AND YEAR(v.fecha) = @AnioLow
GROUP BY p.nombre_producto
ORDER BY CantidadVendida ASC
FOR XML PATH('Producto'), ROOT('Peores5ProductosVendidos');
GO

-- Reporte 7: Total acumulado de ventas para una fecha y sucursal específicas
DECLARE @FechaEspecifica DATE = '2019-01-01', @SucursalID INT = 1;
SELECT 
    v.fecha AS Fecha,
    s.sucursal AS Sucursal,
    dv.id_detalle_venta AS IDDetalleVenta,
    p.nombre_producto AS Producto,
    dv.cantidad AS Cantidad,
    dv.precio_unitario AS PrecioUnitario,
    (dv.cantidad * dv.precio_unitario) AS TotalPorProducto,
    (SELECT SUM(dv2.cantidad * dv2.precio_unitario)
     FROM creacion.detalle_venta AS dv2
     INNER JOIN creacion.venta AS v2 ON dv2.id_venta = v2.id_venta
     WHERE v2.fecha = @FechaEspecifica AND v2.id_sucursal = @SucursalID
    ) AS TotalDia
FROM creacion.detalle_venta AS dv
INNER JOIN creacion.producto AS p ON dv.id_producto = p.id_producto
INNER JOIN creacion.venta AS v ON dv.id_venta = v.id_venta
INNER JOIN creacion.sucursal AS s ON v.id_sucursal = s.id_sucursal
WHERE 
    v.fecha = @FechaEspecifica AND s.id_sucursal = @SucursalID
FOR XML PATH('DetalleVenta'), ROOT('TotalAcumuladoVentas');
GO
