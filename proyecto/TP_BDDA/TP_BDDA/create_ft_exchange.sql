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

    -- Liberar el objeto
    EXEC sp_OADestroy @Object;

    -- Retornar la tasa de cambio como DECIMAL
    RETURN CAST(@tasaDeCambio AS DECIMAL(10,4));
END;
GO