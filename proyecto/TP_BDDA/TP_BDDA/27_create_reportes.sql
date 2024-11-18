USE Com2900G08;
GO

-- 1. Reporte Mensual: Total facturado por días de la semana
DROP PROCEDURE IF EXISTS insertar.reporte_mensual;
GO
CREATE PROCEDURE insertar.reporte_mensual
    @Mes INT,
    @Anio INT
AS
BEGIN
    SELECT 
        DATENAME(WEEKDAY, fecha) AS DiaSemana,
        SUM(monto_total) AS TotalFacturado
    FROM 
        creacion.venta
    WHERE 
        MONTH(fecha) = @Mes AND YEAR(fecha) = @Anio
    GROUP BY 
        DATENAME(WEEKDAY, fecha)
    ORDER BY 
        DiaSemana
    FOR XML PATH('Dia'), ROOT('ReporteMensual');
END;
GO

-- 2. Reporte Trimestral: Total facturado por turnos de trabajo por mes
DROP PROCEDURE IF EXISTS insertar.reporte_trimestral;
GO
CREATE PROCEDURE insertar.reporte_trimestral
    @InicioTrimestre DATE,
    @FinTrimestre DATE
AS
BEGIN
    SELECT 
        DATENAME(MONTH, fecha) AS Mes,
        e.turno AS TurnoTrabajo,
        SUM(v.monto_total) AS TotalFacturado
    FROM 
        creacion.venta v
        INNER JOIN creacion.empleado e ON v.id_empleado = e.id_empleado
    WHERE 
        fecha BETWEEN @InicioTrimestre AND @FinTrimestre
    GROUP BY 
        DATENAME(MONTH, fecha), e.turno
    ORDER BY 
        Mes, TurnoTrabajo
    FOR XML PATH('Mes'), ROOT('ReporteTrimestral');
END;
GO

-- 3. Reporte por Rango de Fechas: Cantidad de productos vendidos ordenado de mayor a menor
DROP PROCEDURE IF EXISTS insertar.reporte_por_rango_de_fechas;
GO
CREATE PROCEDURE insertar.reporte_por_rango_de_fechas
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SELECT 
        p.nombre_producto,
        SUM(dv.cantidad) AS CantidadVendida
    FROM 
        creacion.detalle_venta dv
        INNER JOIN creacion.producto p ON dv.id_producto = p.id_producto
        INNER JOIN creacion.venta v ON dv.id_venta = v.id_venta
    WHERE 
        v.fecha BETWEEN @FechaInicio AND @FechaFin
    GROUP BY 
        p.nombre_producto
    ORDER BY 
        CantidadVendida DESC
    FOR XML PATH('Producto'), ROOT('ReportePorRangoDeFechas');
END;
GO

-- 4. Reporte por Rango de Fechas: Cantidad de productos vendidos por sucursal
DROP PROCEDURE IF EXISTS insertar.reporte_por_sucursal;
GO
CREATE PROCEDURE insertar.reporte_por_sucursal
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SELECT 
        s.sucursal,
        p.nombre_producto,
        SUM(dv.cantidad) AS CantidadVendida
    FROM 
        creacion.detalle_venta dv
        INNER JOIN creacion.producto p ON dv.id_producto = p.id_producto
        INNER JOIN creacion.venta v ON dv.id_venta = v.id_venta
        INNER JOIN creacion.sucursal s ON v.id_sucursal = s.id_sucursal
    WHERE 
        v.fecha BETWEEN @FechaInicio AND @FechaFin
    GROUP BY 
        s.sucursal, p.nombre_producto
    ORDER BY 
        CantidadVendida DESC
    FOR XML PATH('ProductoPorSucursal'), ROOT('ReportePorSucursal');
END;
GO

-- 5. Reporte: 5 Productos Más Vendidos en un Mes, por Semana
DROP PROCEDURE IF EXISTS insertar.reporte_mas_vendidos;
GO
CREATE PROCEDURE insertar.reporte_mas_vendidos
    @Year INT,
    @Month INT
AS
BEGIN
    WITH ProductosVendidos AS (
        SELECT 
            DATEPART(WEEK, v.fecha) AS Semana,
            p.nombre_producto,
            SUM(dv.cantidad) AS CantidadVendida
        FROM 
            creacion.detalle_venta dv
            INNER JOIN creacion.producto p ON dv.id_producto = p.id_producto
            INNER JOIN creacion.venta v ON dv.id_venta = v.id_venta
        WHERE 
            YEAR(v.fecha) = @Year AND MONTH(v.fecha) = @Month
        GROUP BY 
            DATEPART(WEEK, v.fecha), p.nombre_producto
    )
    SELECT TOP 5
        Semana,
        nombre_producto,
        CantidadVendida
    FROM 
        ProductosVendidos
    ORDER BY 
        Semana, CantidadVendida DESC
    FOR XML PATH('Producto'), ROOT('ReporteMasVendidos');
END;
GO

-- 6. Reporte: 5 Productos Menos Vendidos en un Mes
DROP PROCEDURE IF EXISTS insertar.reporte_menos_vendidos;
GO
CREATE PROCEDURE insertar.reporte_menos_vendidos
    @Year INT,
    @Month INT
AS
BEGIN
    SELECT TOP 5
        p.nombre_producto,
        SUM(dv.cantidad) AS CantidadVendida
    FROM 
        creacion.detalle_venta dv
        INNER JOIN creacion.producto p ON dv.id_producto = p.id_producto
        INNER JOIN creacion.venta v ON dv.id_venta = v.id_venta
    WHERE 
        YEAR(v.fecha) = @Year AND MONTH(v.fecha) = @Month
    GROUP BY 
        p.nombre_producto
    ORDER BY 
        CantidadVendida ASC
    FOR XML PATH('Producto'), ROOT('ReporteMenosVendidos');
END;
GO

-- 7. Reporte: Total Acumulado de Ventas para una Fecha y Sucursal Particular
DROP PROCEDURE IF EXISTS insertar.reporte_total_acumulado;
GO
CREATE PROCEDURE insertar.reporte_total_acumulado
    @Fecha DATE,
    @SucursalID INT
AS
BEGIN
    SELECT 
        v.fecha,
        s.sucursal,
        v.monto_total,
        dv.cantidad,
        p.nombre_producto,
        dv.subtotal
    FROM 
        creacion.venta v
        INNER JOIN creacion.sucursal s ON v.id_sucursal = s.id_sucursal
        INNER JOIN creacion.detalle_venta dv ON v.id_venta = dv.id_venta
        INNER JOIN creacion.producto p ON dv.id_producto = p.id_producto
    WHERE 
        v.fecha = @Fecha AND s.id_sucursal = @SucursalID
    FOR XML PATH('VentaDetalle'), ROOT('ReporteTotalAcumulado');
END;
GO
