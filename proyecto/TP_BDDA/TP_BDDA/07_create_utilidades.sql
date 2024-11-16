USE Com2900G08
GO

DROP FUNCTION IF EXISTS insertar.obtenerTasaCambioUSD_ARS;
GO
CREATE FUNCTION insertar.obtenerTasaCambioUSD_ARS()
RETURNS DECIMAL(10,4)
AS
BEGIN
    DECLARE @tasaDeCambio CHAR(8);
    DECLARE @url NVARCHAR(64) = 'https://api.exchangerate-api.com/v4/latest/usd';
    DECLARE @Object INT;
    DECLARE @ResponseText VARCHAR(8000);

    -- Crear el objeto para realizar la solicitud HTTP
    EXEC sp_OACreate 'MSXML2.ServerXMLHTTP', @Object OUT;
    EXEC sp_OAMethod @Object, 'open', NULL, 'GET', @url, 'false';
    EXEC sp_OAMethod @Object, 'send';
    EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT;

    -- Extraer el valor de la tasa de cambio ARS del JSON
    SELECT @tasaDeCambio = JSON_VALUE(@ResponseText, '$.rates.ARS');

    EXEC sp_OADestroy @Object;

    -- Retornar la tasa de cambio como DECIMAL
    RETURN CAST(@tasaDeCambio AS DECIMAL(10,4));
END;
GO

USE Com2900G08
GO


DROP PROCEDURE IF EXISTS utilitarias.GenerarNumeroFactura
GO

CREATE PROCEDURE utilitarias.GenerarNumeroFactura 
    @numeroFactura CHAR(30) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Parte1 NVARCHAR(3) = RIGHT('0000' + CAST(ROUND(RAND() * 9999, 0) AS NVARCHAR), 4)
    DECLARE @Parte2 NVARCHAR(2) = RIGHT('00' + CAST(ROUND(RAND() * 99, 0) AS NVARCHAR), 2)
    DECLARE @Parte3 NVARCHAR(4) = RIGHT('0000' + CAST(ROUND(RAND() * 9999, 0) AS NVARCHAR), 4)
    SET @numeroFactura = @Parte1 + '-' + @Parte2 + '-' + @Parte3
END;
GO

DROP TYPE IF EXISTS utilitarias.ProductoCantidadType
GO
-- Crear el tipo de tabla que usaremos como parámetro de detalle de venta
CREATE TYPE utilitarias.ProductoCantidadType AS TABLE
(
    id_producto INT,
    cantidad INT
);